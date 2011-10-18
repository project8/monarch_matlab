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
  % otherwise, we have a real handle.  pass it on in.
  if strcmp(err_msg,'') == 0
    error(err_msg)
  else
    new_egg.handle = handle;
  end

  % now we grab the prelude and figure out what is in there.
  [prelude, ~] = fread(new_egg.handle,8,'char');
  hdr_bytes = sscanf(char(transpose(prelude)),'%08x');

  % read the header and stick it in the return.
  [header, ~] = fread(new_egg.handle,hdr_bytes,'char');

  % maybe some day there will be a nice way to do this.
  tmpfilename = '/tmp/mm_tmp';
  [tmp_handle, err_msg] = fopen(tmpfilename,'w');
  if strcmp(err_msg,'') == 0
      error(['in tmp file: ', err_msg]);
  else 
      fwrite(tmp_handle, header);
      fclose(tmp_handle);
  end

  % now parse the temporary file.
  parsed_header = xml2struct(tmpfilename);
  
  % ok, now for each child, get the data out that we care about.
  for child = parsed_header.children
      % if it's the data format, we get both the total record size
      % and the size of just the data portion of the record (called
      % the data width)
      if strcmp(child.name,'data_format') == 1
          new_egg.record_size = 0;
          for attr = child.attributes
              val = sscanf(attr.value,'%d');
              if strcmp(attr.name,'data') == 1
                  new_egg.data_width = val;
              end
              new_egg.record_size = new_egg.record_size + val;
          end
      % if it's the digitizer, we pull out the rate information
      elseif strcmp(child.name,'digitizer') == 1
          val = sscanf(child.attributes(1).value,'%d');
          new_egg.digitizer_rate = val;
      end
  end
end