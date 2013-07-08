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
        comErrors = '';
        resetErrors = '';
        return;
    end
elseif rawType == 2 % uint16 binary with separate header file
    try
        [deviceID, time, activity, resets] = readRawUint16(filePath);
    catch err
        deviceID = 'File skipped';
        comErrors = '';
        resetErrors = '';
        return;
    end
else
    deviceID = 'Invalid file';
    comErrors = '';
    resetErrors = '';
    return;
end

%% Set date formatting
dateFormat = 'mm/dd/yy HH:MM';

%% Summarize communication errors
% Find communication errors
comIdx = activity == 0; % | activity > 4;
comIdx = comIdx(:);
if max(comIdx) == 0
    comErrors = 'No com. errors detected';
else
    % Find start and end times of error clusters
    comIdxPlus1 = circshift(comIdx,1);
    startsIdx = comIdx == 1 & comIdxPlus1 == 0;
    endsIdx = comIdx == 0 & comIdxPlus1 == 1;
    startTimes = time(startsIdx);
    endTimes = time(endsIdx);
    % Find the number of error clusters
    nComErr = min([length(startTimes),length(endTimes)]);
    % Create string summary to return
    comErrors0 = [num2str(nComErr),' communication errors at approx. '];
    l1 = length(comErrors0);
    l2 = length([', ',dateFormat,' - ',dateFormat]);
    % Preallocate the string
    comErrors = char(zeros(l1+l2*nComErr,1));
    comErrors(1:l1) = comErrors0;
    for i1 = 1:nComErr
        j1 = l1 + 1 + l2 * (i1 - 1);
        j2 = j1 + l2 - 1;
        comErrors(j1:j2) = [', ',datestr(startTimes(i1),dateFormat),' - ',...
            datestr(endTimes(i1),dateFormat)];
    end
end

%% Summarize resets
resets = resets(:);
if max(resets) == 0
    resetErrors = 'No resets detected';
else
    nResetErr = sum(resets);
    resetTimes = time(resets);
    resetErrors0 = [num2str(nResetErr),' reset errors at approx. '];
    l3 = length(resetErrors0);
    l4 = length([', ',dateFormat]);
    % Preallocate the string
    resetErrors = char(zeros(l3+l4*nResetErr,1));
    resetErrors(1:l3) = resetErrors0;
    for i2 = 1:nResetErr
        j3 = l3 + 1 + l4 * (i1 - 1);
        j4 = j3 + l4 - 1;
        resetErrors(j3:j4) = [', ',datestr(resetTimes(i1),dateFormat)];
    end
end


end

