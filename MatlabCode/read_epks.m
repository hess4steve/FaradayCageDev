%
% function [times, avg, resp] = read_epks(filename, Fs)
%

function [times, avg, resp] = read_epks(filename, Fs)

T = readtable(filename, 'ReadVariableNames',false);

varnames = T.Properties.VariableNames;
num_recordings = length(varnames);

resp = cell(num_recordings, 1);
avg = 0;

i=0;
for var=varnames
    avg = avg + T.(var{:})/num_recordings;
    i=i+1;
    resp{i} = T.(var{:});
end

times = (0:length(T.Var1)-1)/Fs;

