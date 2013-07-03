function [ deviceID, comErrors, resetErrors ] = checkFile( fileName )
%CHECKFILE checks a Daysimeter file for communication errors and resets
%   Returns the device ID and a summary of communication errors and resets

%% Read file
% Determine type of raw file
rawType = rawTest(fileName);
% Process file
if rawType == 1
    [time, activity, resets] = readFile1(fileName);
else % rawType == 2
    [time, activity, resets] = readFile2(fileName);
end

%% Find device ID
fileName = regexprep(fileName,'day','ID','ignorecase');
fileName = regexprep(fileName,'dime','ID','ignorecase');
regexResult = regexpi(fileName,'ID(\d.)','tokens');
deviceID = regexResult{1};

%% Find communication errors
comIdx = activity == 0 | activity > 2;

%% Summarize communication errors
countComErr = sum(comIdx);
comIdxPlus1 = circshift(comIdx,1);
startsIdx = comIdx == 1 & comIdxPlus1 == 0;
endsIdx = comIdx == 0 & comIdxPlus1 == 1;
startTimes = time(startsIdx);
endTimes = time(endsIdx);

%% Find resets


%% Summarize resets



end

