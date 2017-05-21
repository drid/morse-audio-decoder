pkg load signal
clear w1 ind len

_PLAYBACK = false;
_PLOT = false;
% temporal symbol thresholds detection
symbol_threshold = 4000
letter_threshold = 4000

if (exist("fpath", "var") == 0)
  fpath = ""
endif

% read file
[filename fpath] = uigetfile({"*.wav;*.ogg", "Audio file"}, 'Select audio file', fpath);

audio=audioread(strcat(fpath,filename));

% Filter audio
w1=medfilt1(abs(audio), 1000);
clear audio;

% Convert to logic levels
level_threshold = (max(w1)-min(w1))/2+min(w1)

if _PLOT
  plot(w1)
  hold
  plot([0,length(w1)], [level_threshold, level_threshold], "color","r")
endif

w1(w1 > level_threshold) =1;
w1(w1 < level_threshold) =0;

% Smooth again
w1 = medfilt1(w1, 100);
w1 = not(w1);

% Detect transitions
ind = find(diff(w1))+1;
len=diff([1; ind]);

morseC='';
packet='';

packetList={};

%% Playback
if _PLAYBACK
% carrier generation
  bps = 16;       % bits per sample
  sps = 32000;     % sample rate [samples/s]
  freq = 600;       % frequency of the tone [Hz]
  nsecs = length(w1)/sps;      % number of seconds of the audio file

  nsamples = sps*nsecs;

  time = linspace(0, nsecs, nsamples);
  carrier = sin(time*2*pi*freq)';

  %ws=w1(1:size(carrier));

  wc = carrier(1:length(w1)) .* w1;

  sound(wc, sps);
endif

% Detect morse letters
for idx = w1(1)+2:2:size(len)-1
  if len(idx) > symbol_threshold
    morseC = strcat(morseC, "-");
   else
    morseC = strcat(morseC, ".");
   endif

  if len(idx+1) > letter_threshold
    packet = strcat(packet, morse2char(morseC));
    %printf ("%s %s\n", morse2char(morseC), morseC);
    morseC='';
  endif

  if len(idx+1) > 4*letter_threshold
    packetList{end+1} = packet;
    packet = "";
  endif
  
endfor
packetList{end+1} = packet;

%%%% UPSat specific code
% Source info
source = "N/A";
timestamp = "";
[source, timestamp] = sourceFileInfo(filename);

% UPSat Decode
packetList
for i=1:length(packetList)
  if length(packetList{i}) >5
    upsatDecode(packetList{i}, source, timestamp);
  endif
endfor

