function [ rawType ] = rawTest( filePath )
%FILETYPE Determines file type based on the file name

[~, fileName, fileExt] = fileparts(filePath);

if strcmpi(fileExt,'.raw')
    rawType = 1; % bitwise text
elseif strcmpi(fileExt,'.bin') && strcmpi(regexprep(fileName,'.*header.*','header','ignorecase'),'header')
    rawType = 0; % text header file
elseif strcmpi(fileExt,'.bin')
    rawType = 2; % uint16 binary
else
    rawType = 0; % Invalid
end

end

