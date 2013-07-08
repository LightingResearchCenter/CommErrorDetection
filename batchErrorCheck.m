function batchErrorCheck
%BATCHERRORCHECK Summary of this function goes here
%   Detailed explanation goes here

dirName = uigetdir;
dirInfo = dir(fullfile(dirName,'*data_log.txt'));
saveFile = fullfile(dirName,'error_log.txt');
fid = fopen(saveFile,'a+');

for i1 = 1:length(dirInfo)
    filePath = fullfile(dirName, dirInfo(i1,1).name);
    [ deviceID, comErrors, resetErrors ] = checkFile( filePath );
    fprintf(fid,'%s\f\n%s\f\n%s\f\n',deviceID,comErrors,resetErrors);
end

fclose(fid)

end

