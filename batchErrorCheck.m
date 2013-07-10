function batchErrorCheck
%BATCHERRORCHECK Summary of this function goes here
%   Detailed explanation goes here

dirName = uigetdir;
dirInfo1 = dir(fullfile(dirName,'*data_log.txt'));
dirInfo2 = dir(fullfile(dirName,'*.raw'));
dirInfo = [dirInfo1;dirInfo2];
saveFile = fullfile(dirName,'error_log.txt');
fid = fopen(saveFile,'w+');

nFiles = length(dirInfo);

fileNames = cell(nFiles,1);
for i1 = 1:nFiles
    fileNames{i1} = dirInfo(i1,1).name;
end

fileID = regexprep(fileNames,'Day(\d{2})_(\d{6})_(\d{4})\..+','0$1$2$3');
fileID = regexprep(fileID,'Day(\d{3})_(\d{6})_(\d{4})\..+','$1$2$3');
fileNum = str2double(fileID);
fileDevice = str2double(regexprep(fileNames,'Day(\d+)_.*','$1'));

for i2 = 1:nFiles
    idx1 = fileDevice == fileDevice(i2);
    fileGroup = fileNum(idx1);
    idx2 = fileGroup < fileNum(i2);
    fileNum2 = max(fileGroup(idx2));
    if ~isempty(fileNum2)
        idx3 = fileNum == fileNum2;
        filePath1 = fullfile(dirName, dirInfo(i2,1).name);
        filePath2 = fullfile(dirName, dirInfo(idx3,1).name);

        [deviceID,comErrors,resetErrors] = checkFile(filePath1,filePath2);
        nComErrors = length(comErrors);
        nResetErrors = length(resetErrors);
        comErrorsHead = [num2str(nComErrors),' errors'];
        resetErrorsHead = [num2str(length(resetErrors)),' resets'];
        spacer1 = repmat(' ',1,length(dirInfo(i2,1).name));
        spacer2 = repmat(' ',1,length(['SN: ',deviceID]));
        if ~isempty(comErrors)
            spacer3 = repmat(' ',1,max([length(comErrorsHead),length(comErrors{1})]));
            if length(comErrors{1}) > length(comErrorsHead)
                spacer5 = repmat(' ',1,length(comErrors{1})-length(comErrorsHead));
            else
                spacer5 = '';
                spacer6 = repmat(' ',1,length(comErrorsHead)-length(comErrors{1}));
            end
        else
            spacer3 = repmat(' ',1,length(comErrorsHead));
            spacer5 = '';
            spacer6 = '';
        end
        if ~isempty(resetErrors)
            spacer4 = repmat(' ',1,max([length(resetErrorsHead),length(resetErrors{1})]));
        else
            spacer4 = repmat(' ',1,length(resetErrorsHead));
        end
        
        fprintf(fid,'%s\tSN: %s\t%s%s\t%s\r\n',dirInfo(i2,1).name,deviceID,comErrorsHead,spacer5,resetErrorsHead);
        
        for j1 = 1:max([nComErrors,nResetErrors])
            if j1 <= nComErrors
                fprintf(fid,'%s\t%s\t%s%s\t',spacer1,spacer2,comErrors{j1},spacer6);
            else
                fprintf(fid,'%s\t%s\t%s\t',spacer1,spacer2,spacer3);
            end
            if j1 <= nResetErrors
                fprintf(fid,'%s\r\n',resetErrors{j1});
            else
                fprintf(fid,'%s\r\n',spacer4);
            end
        end
        for j2 = 1:length(resetErrors)
            
        end
    end
end

fclose(fid);

end

