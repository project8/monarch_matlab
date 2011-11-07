% mConvertToVoltage.m
% written by jared kofron <jared.kofron@gmail.com>
% takes a monarch event and transforms the raw digitizer
% data into voltage values.
function new_event = mConvertToVoltage(event)
new_event = event;
if isequal(event.data_type,'uint32')
    bit_width = 2^8;
    trans = @(x) -0.25 + (x/(bit_width-1))*.5;
    new_event.data = arrayfun(trans,new_event.data);
end
% otherwise do nothing
end