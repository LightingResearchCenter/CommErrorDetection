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
        fprintf(fid,'%s\r\n\tDevice ID: %s\r\n',dirInfo(i2,1).name,deviceID);
        if length(comErrors) == 1
            fprintf(fid,'\t%s\r\n',comErrors{1});
        else
            fprintf(fid,'\t%s\r\n',comErrors{1});
            for j1 = 2:length(comErrors)
                fprintf(fid,'\t\t%s\r\n',comErrors{j1});
            end
        end
        if length(resetErrors) == 1
            fprintf(fid,'\t%s\r\n',resetErrors{1});
        else
            fprintf(fid,'\t%s\r\n',resetErrors{1});
            for j2 = 2:length(resetErrors)
                fprintf(fid,'\t\t%s\r\n',resetErrors{j2});
            end
        end
    end
end

fclose(fid);

end

