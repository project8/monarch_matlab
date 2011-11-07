% mGetNextEvent.m
% Given an open egg, returns the next event in the file.
function event = mGetNextEvent(current_egg)
    event = struct();
    event.data_type = 'uint32';
% read.
  [raw,nbytes] = fread(current_egg.handle,current_egg.record_size);
  if nbytes == 0
      event.id = -1;
      event.ts = -1;
      event.data = [];
  else
      raw = transpose(raw);
      event.id = typecast(raw(1:8),'uint32');
      event.ts = typecast(raw(9:17),'uint32');
      event.data = raw(18:end);
  end
end