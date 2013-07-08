function [deviceID, time, activity, resets] = readRawUint16(dataPath)
% READRAWUINT16 processes Daysimeter files that have been downloaded directly

[dataDir, dataName, dataExt] = fileparts;
infoPath = fullfile(dataDir, [dataName,'_log_info',dataExt]);

% read the header file
fid = fopen(infoPath,'r','b');
I = fread(fid,'uchar');
fclose(fid);

% read the data file
fid = fopen(dataPath,'r','b');
D = fread(fid,'uint16');
fclose(fid);

% find the ID number
q = find(I==10,4,'first');
deviceID = char(I(q(1)+1:q(1)+4))';
% IDnum = str2double(deviceID);

% find the start date time
startDateTimeStr = char(I(q(2)+1:q(2)+14))';
startTime = datenum(startDateTimeStr,'mm-dd-yy HH:MM');

% find the log interval
logInterval = str2double(char(I(q(3)+1:q(3)+5))');

% seperate data into raw R,G,B,A
A = zeros(1,floor(length(D)/4));
for i1 = 1:floor(length(D)/4)
    A(i1) = D((i1-1)*4+4);
end

% remove unwritten (value = 65535)
unwritten = A == 65535;
A(unwritten) = [];

% consolidate resets and remove extra (value = 65278)
resets0 = R == 65278;
resets = circshift(resets0(:),-1);
A(resets0) = [];
resets(resets0) = [];

% create a time array
time = (1:length(A))/(1/logInterval*60*60*24)+startTime;

% convert activity to rms g
% raw activity is a mean squared value, 1 count = .0039 g's, and the 4 comes
% from four right shifts in the source code
activity = (sqrt(A))*.0039*4;

activity = filter5min(activity,logInterval);

end