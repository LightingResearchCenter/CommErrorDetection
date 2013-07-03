function [ deviceID, comErrors, resets ] = checkFile( fileName )
%CHECKFILE checks a Daysimeter file for communication errors and resets
%   Returns the device ID and a summary of communication errors and resets

%% Read file


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

