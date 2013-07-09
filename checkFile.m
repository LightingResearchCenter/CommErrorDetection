function [ deviceID, comErrors, resetErrors ] = checkFile( filePath )
%CHECKFILE checks a Daysimeter file for communication errors and resets
%   Returns the device ID and a summary of communication errors and resets

%% Read file
% Determine type of raw file
rawType = rawTest(filePath);
% Process raw file based on type
if rawType == 1 % bitwise text file
    try
        [deviceID, time, activity, resets] = readRawAsciiByte(filePath);
    catch err
        deviceID = 'File skipped';
        comErrors = {''};
        resetErrors = {''};
        return;
    end
elseif rawType == 2 % uint16 binary with separate header file
    try
        [deviceID, time, activity, resets] = readRawUint16(filePath);
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

%% Set date formatting
dateFormat = 'mm/dd/yy HH:MM';

%% Summarize communication errors
% Find communication errors
comIdx = activity == 0; % | activity > 4;
comIdx = comIdx(:);
if max(comIdx) == 0
    comErrors = {'No com. errors detected'};
else
    % Find start and end times of error clusters
    comIdxPlus1 = circshift(comIdx,1);
    startsIdx = comIdx == 1 & comIdxPlus1 == 0;
    endsIdx = comIdx == 0 & comIdxPlus1 == 1;
    startTimes = time(startsIdx);
    endTimes = time(endsIdx);
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
    resetTimes = time(resets);
    % Create summary
    resetErrors = cell(nResetErr+1,1);
    resetErrors{1} = [num2str(nResetErr),' reset errors at approximately:'];
    for i2 = 1:nResetErr
        resetErrors{i2+1} = datestr(resetTimes(i2),dateFormat);
    end
end


end

