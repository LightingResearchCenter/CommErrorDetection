function [deviceID, time, R, G, B, activity, resets] = readRawAsciiByte(dataPath)
% READRAWUINT16 processes Daysimeter files that have been downloaded as
% ASCII byte format

% read the file
fid = fopen(dataPath);
scan = textscan(fid, '%f');
raw = scan{1};
fclose(fid);
header = raw(1:1024);
data = raw(1025:end);

%organize data in to rgba
deviceID = num2str((header(4) - 48)*1000 + (header(5) - 48)*100 + (header(6) - 48)*10 + (header(7) - 48));
month = (header(10) - 48)*10 + (header(11) - 48);
day = (header(13) - 48)*10 + (header(14) - 48);
year = (header(16) - 48)*10 + (header(17) - 48);
hour = (header(19) - 48)*10 + (header(20) - 48);
minute = (header(22) - 48)*10 + (header(23) - 48);
logInterval = (header(26) - 48)*100 + (header(27) - 48)*10 + (header(28) - 48);
startTime = datenum(year,month,day,hour,minute,0);
j = 1;
for i = 1:8:length(data)
    A(j) = (256*data(i + 6) + data(i + 7));
    R(j) = 256*data(j) + data(j + 1);
    G(j) = 256*data(j + 2) + data(j + 3);
    B(j) = 256*data(j + 4) + data(j + 5);
    j = j + 1;
end



% remove unwritten (value = 65535)
unwritten = R == 65535;
R(unwritten) = [];
G(unwritten) = [];
B(unwritten) = [];
A(unwritten) = [];

% consolidate resets and remove extra (value = 65278)
resets0 = R == 65278;
resets = circshift(resets0(:),-1);
R(resets0) = [];
G(resets0) = [];
B(resets0) = [];
A(resets0) = [];
resets(resets0) = [];

% create a time array
time = (1:length(R))/(1/logInterval*60*60*24)+startTime;

% convert activity to rms g
% raw activity is a mean squared value, 1 count = .0039 g's, and the 4 comes
% from four right shifts in the source code
activity = (sqrt(A))*.0039*4;

activity = filter5min(activity,logInterval);

end