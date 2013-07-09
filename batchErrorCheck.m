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
    fprintf(fid,'%s\r\n\tDevice ID: %s\r\n',dirInfo1(i1,1).name,deviceID);
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

for i2 = 1:length(dirInfo2)
    filePath = fullfile(dirName, dirInfo2(i2,1).name);
    [ deviceID, comErrors, resetErrors ] = checkFile( filePath );
    fprintf(fid,'%s\r\n\tDevice ID: %s\r\n',dirInfo1(i1,1).name,deviceID);
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

fclose(fid);

end

