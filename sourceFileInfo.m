function [source, timestamp] = sourceFileInfo(filename)
  % Source from filename
  [z, bareFName, z] = fileparts(filename)
  sourceInfo = strsplit(bareFName, "_")
  if strcmpi(sourceInfo{1}, "satnogs")
    source = strcat("https://network.satnogs.org/observations/data/", sourceInfo{2});
    timestamp = sourceInfo{3}
  endif
endfunction