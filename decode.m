pkg load signal
%clear all

_PLAYBACK = false;
_PLOT = false;

if (exist("fpath", "var") == 0)
  fpath = ""
endif

% read file
[filename fpath] = uigetfile({"*.wav;*.ogg", "Audio file"}, 'Select audio file', fpath)

audio=audioread(strcat(fpath,filename));

w1=medfilt1(abs(audio), 1000);

level_threshold = mean(w1)

if _PLOT
  plot(w1)
  hold
  plot([0,length(w1)], [level_threshold, level_threshold])
endif

w1(w1 > level_threshold) =1;
w1(w1 < level_threshold) =0;

w1 = medfilt1(w1, 100);
w1 = not(w1);

ind = find(diff(w1))+1;
len=diff([1; ind]);

symbol_threshold = max(len(2:2:end))/2;
letter_threshold = min(len(1:2:end))*2;

morseC='';
packet='';

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
endfor

printf("Packet: %s\n", packet)

% UPSat Decode
upsatDecode(packet);

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
