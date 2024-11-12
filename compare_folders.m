clearvars; 

% Define directories
dir_new = "";
dir_old = "";

% Get lists of all files and folders with full path
files_new = dir(fullfile(dir_new, '**', '*')); 
files_old = dir(fullfile(dir_old, '**', '*'));

disp("Find separate files and folders.");

% Separate files and directories for new directory
filePaths_new = files_new(~[files_new.isdir]);
folderPaths_new = files_new([files_new.isdir]);

% Separate files and directories for old directory
filePaths_old = files_old(~[files_old.isdir]);
folderPaths_old = files_old([files_old.isdir]);

disp("Extract relative paths.");

% Extract relative paths for files in both directories, removing the "DICOM/" prefix
relPaths_new_files = cellfun(@(x) extractAfter(x, dir_new), {filePaths_new.folder}, 'UniformOutput', false);
relPaths_old_files = cellfun(@(x) extractAfter(x, dir_old), {filePaths_old.folder}, 'UniformOutput', false);
relPaths_new_files = strcat(relPaths_new_files, filesep, {filePaths_new.name});
relPaths_old_files = strcat(relPaths_old_files, filesep, {filePaths_old.name});

disp("Find missing files.");

% Find missing or extra files by comparing relative paths
missingIn_new_files = setdiff(relPaths_old_files, relPaths_new_files);
missingIn_old_files = setdiff(relPaths_new_files, relPaths_old_files);

% Display results for files
if isempty(missingIn_old_files) && isempty(missingIn_new_files)
    disp('All files correctly transferred');
else
    if ~isempty(missingIn_new_files)
        disp('Files missing in new dir:');
        disp(missingIn_new_files');
    end 
    if ~isempty(missingIn_old_files)
        disp('Extra files in old dir:');
        disp(missingIn_old_files');
    end
end


