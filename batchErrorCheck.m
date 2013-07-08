function batchErrorCheck
%BATCHERRORCHECK Summary of this function goes here
%   Detailed explanation goes here

startDir = 'C:\Users\jonesg5\Desktop\HANDLS';
dirName = uigetdir(startDir);
dirInfo = dir(fullfile(dirName,'*data_log.txt'));
saveFile = fullfile(dirName,'error_log.txt');
fid = fopen(saveFile,'w+');

for i1 = 1:length(dirInfo)
    filePath = fullfile(dirName, dirInfo(i1,1).name);
    [ deviceID, comErrors, resetErrors ] = checkFile( filePath );
    fprintf(fid,'%s\r\n\tDevice ID: %s\r\n\t%s\r\n\t%s\r\n',dirInfo(i1,1).name,deviceID,comErrors,resetErrors);
end

fclose(fid);

end

