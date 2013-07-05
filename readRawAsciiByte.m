function [deviceID, time, activity, resets] = readRawAsciiByte(dataPath)
% READRAWUINT16 processes Daysimeter files that have been downloaded as
% ASCII byte format

% read the file
fid = fopen(dataPath,'r','b');
raw = fread(fid,'uchar');
fclose(fid);

%organize data in to rgba
n = floor(length(raw)/8 - 2);
time = -1*ones(n,1);
A = -1*ones(n,1);
for i = 24:8:length(raw) % the first 16 bytes are the header if one exists
    time(i/8 - 2) = datenum(start) + (int/86400)*(i/8 - 3);
    A(i/8 - 2) = 256*raw(i - 1) + raw(i);
    A(i/8 - 2) = A(i/8 - 2)/2;
end

% remove unwritten (value = 65535)
unwritten = A == 65535;
A(unwritten) = [];

% consolidate resets and remove extra (value = 65278)
resets0 = A == 65278;
resets = circshift(resets0(:));
A(resets0) = [];
resets(resets0) = [];

% convert activity to rms g
% raw activity is a mean squared value, 1 count = .0039 g's, and the 4 comes
% from four right shifts in the source code
activity = (sqrt(A))*.0039*4;

activity = filter5min(activity,logInterval);

end