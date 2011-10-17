% mBreakEgg.m
% opens a .egg file for reading.  parses the XML header and so on
% and so forth without additional user intervention.  input is 
% simply a filename, and the return value is a struct with a bunch
% of fields filled.  this struct is the input for other calls in
% the monarch library.
function new_egg = mBreakEgg(filename)
  % initialize the return value
  new_egg = struct();

  % try to open the file specified by filename
  [handle, err_msg] = fopen(filename,'r');
  % if the error message is not empty, something terrible happened.
  if strcmp(err_msg,'') == 0
    error(err_msg)
  else

  new_egg.handle = handle;
end