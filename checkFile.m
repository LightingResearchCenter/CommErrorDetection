function [ deviceID, comErrors, resetErrors ] = checkFile( filePath1, filePath2 )
%CHECKFILE checks a Daysimeter file for communication errors and resets
%   Returns the device ID and a summary of communication errors and resets

%% Read file
% Determine type of raw file
rawType = rawTest(filePath1);
% Process raw file based on type
if rawType == 1 % bitwise text file
    try
        [deviceID, time1, R1, G1, B1, A1, resets] = readRawAsciiByte(filePath1);
        [~       , time2, R2, G2, B2, A2, ~     ] = readRawAsciiByte(filePath2);
    catch err
        deviceID = 'File skipped';
        comErrors = {''};
        resetErrors = {''};
        return;
    end
elseif rawType == 2 % uint16 binary with separate header file
    try
        [deviceID, time1, R1, G1, B1, A1, resets] = readRawUint16(filePath1);
        [~       , time2, R2, G2, B2, A2, ~     ] = readRawUint16(filePath2);
    catch err
        deviceID = 'File skipped';
        comErrors = {''};
        resetErrors = {''};
        return;
    end
else
    deviceID = 'Invalid file';
    comErrors = {''};
    resetErrors = {''};
    return;
end

%% Shorten the data to the same length
idx = 1:min(length(time1),length(time2));
time1 = time1(idx);
R1 = R1(idx);
G1 = G1(idx);
B1 = B1(idx);
A1 = A1(idx);
resets = resets(idx);
time2 = time2(idx);
R2 = R2(idx);
G2 = G2(idx);
B2 = B2(idx);
A2 = A2(idx);

%% Set date formatting
dateFormat = 'mm/dd/yy HH:MM';

%% Summarize communication errors
% Find communication errors
comIdx = R1~=R2 | G1~=G2 |  B1~=B2 | A1~=A2;
comIdx = comIdx(:);
if max(comIdx) == 0
    comErrors = {'No com. errors detected'};
else
    % Find start and end times of error clusters
    comIdxPlus1 = circshift(comIdx,1);
    startsIdx = comIdx == 1 & comIdxPlus1 == 0;
    endsIdx = comIdx == 0 & comIdxPlus1 == 1;
    startTimes = time1(startsIdx);
    endTimes = time1(endsIdx);
    % Find the number of error clusters
    nComErr = min([length(startTimes),length(endTimes)]);
    % Create summary
    comErrors = cell(nComErr+1,1);
    comErrors{1} = [num2str(nComErr),' communication errors at approximately:'];
    for i1 = 1:nComErr
        comErrors{i1+1} = [datestr(startTimes(i1),dateFormat),' - ',...
            datestr(endTimes(i1),dateFormat)];
    end
end

%% Summarize resets
resets = resets(:);
if max(resets) == 0
    resetErrors = {'No resets detected'};
else
    nResetErr = sum(resets);
    resetTimes = time1(resets);
    % Create summary
    resetErrors = cell(nResetErr+1,1);
    resetErrors{1} = [num2str(nResetErr),' reset errors at approximately:'];
    for i2 = 1:nResetErr
        resetErrors{i2+1} = datestr(resetTimes(i2),dateFormat);
    end
end


end

