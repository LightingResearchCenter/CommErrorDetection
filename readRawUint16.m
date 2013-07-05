function [deviceID, time, activity, resets] = readRawUint16(dataPath)
% READRAW processes Daysimeter files that have been downloaded directly

[dataDir, dataName, dataExt] = fileparts;
infoPath = fullfile(dataDir, [dataName,'_header',dataExt]);

% read the header file
fid = fopen(infoPath,'r','b');
I = fread(fid,'uchar');
fclose(fid);

% read the data file
fid = fopen(dataPath,'r','b');
D = fread(fid,'uint16');
fclose(fid);

% find the ID number
unwritten = find(I==10,4,'first');
deviceID = char(I(unwritten(1)+1:unwritten(1)+4))';
% IDnum = str2double(deviceID);

% find the start date time
startDateTimeStr = char(I(unwritten(2)+1:unwritten(2)+14))';
startTime = datenum(startDateTimeStr,'mm-dd-yy HH:MM');

% find the log interval
logInterval = str2double(char(I(unwritten(3)+1:unwritten(3)+5))');

% seperate data into raw R,G,B,A
R = zeros(1,floor(length(D)/4));
% G = zeros(1,floor(length(D)/4));
% B = zeros(1,floor(length(D)/4));
A = zeros(1,floor(length(D)/4));
for i1 = 1:floor(length(D)/4)
    R(i1) = D((i1-1)*4+1);
%     G(i1) = D((i1-1)*4+2);
%     B(i1) = D((i1-1)*4+3);
    A(i1) = D((i1-1)*4+4);
end

% remove unwritten (value = 65535)
unwritten = R == 65535;
R(unwritten) = [];
% G(unwritten) = [];
% B(unwritten) = [];
A(unwritten) = [];

% consolidate resets and remove extra (value = 65278)
resets0 = R == 65278;
resets = circshift(resets0(:));
R(resets0) = [];
% G(resets0) = [];
% B(resets0) = [];
A(resets0) = [];
resets(resets0) = [];


% create a time array
time = (1:length(R))/(1/logInterval*60*60*24)+startTime;

% read R,G,B calibration constants
% g = fopen('\\ROOT\projects\Daysimeter and dimesimeter reference files\data\Day12 RGB Values.txt');
%find line corresponding to id number
% for i = 1:IDnum
%     fgetl(g);
% end

%pull in RGB calibration constants
% fscanf(g, '%d', 1);
% cal = zeros(1,3);
% for i = 1:3
%     cal(i) = fscanf(g, '%f', 1);
% end

% convert activity to rms g
% raw activity is a mean squared value, 1 count = .0039 g's, and the 4 comes
% from four right shifts in the source code
activity = (sqrt(A))*.0039*4;

% calibrate to illuminant A
% red = R*cal(1);
% green = G*cal(2);
% blue = B*cal(3);

% calculate lux and CLA
% [~, CLA] = Day12luxCLA(red, green, blue, IDnum);
% CLA(CLA < 0) = 0;

% filter CLA and activity
% CLA = filter5min(CLA,logInterval);
activity = filter5min(activity,logInterval);

% calculate CS
% CS = CSCalc(CLA);

end