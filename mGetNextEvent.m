% mGetNextEvent.m
% Given an open egg, returns the next event in the file.
function [id,ts,data] = mGetNextEvent(current_egg)
% read.
  [raw,nbytes] = fread(current_egg.handle,current_egg.record_size);
  if nbytes == 0
      id = -1;
      ts = -1;
      data = [];
  else
      raw = transpose(raw);
      id = typecast(raw(1:8),'uint32');
      ts = typecast(raw(9:17),'uint32');
      data = raw(18:end);
  end
end