function batchErrorCheck
%BATCHERRORCHECK Summary of this function goes here
%   Detailed explanation goes here

dirName = uigetdir;
dirInfo1 = dir(fullfile(dirName,'*data_log.txt'));
dirInfo2 = dir(fullfile(dirName,'*.raw'));
saveFile = fullfile(dirName,'error_log.txt');
fid = fopen(saveFile,'w+');

for i1 = 1:length(dirInfo1)
    filePath = fullfile(dirName, dirInfo1(i1,1).name);
    [ deviceID, comErrors, resetErrors ] = checkFile( filePath );
    fprintf(fid,'%s\r\n\tDevice ID: %s\r\n\t%s\r\n\t%s\r\n',dirInfo1(i1,1).name,deviceID,comErrors,resetErrors);
end

for i2 = 1:length(dirInfo2)
    filePath = fullfile(dirName, dirInfo2(i2,1).name);
    [ deviceID, comErrors, resetErrors ] = checkFile( filePath );
    fprintf(fid,'%s\r\n\tDevice ID: %s\r\n\t%s\r\n\t%s\r\n',dirInfo2(i2,1).name,deviceID,comErrors,resetErrors);
end

fclose(fid);

end

