clear all;

% define DME dir
DME_dir='/storage/shared/research/cinn/2018/MAGMOT/DME';

% add SPM dir
spm_dir=[DME_dir '/spm12'];
addpath(spm_dir);
spm fmri

% define path where dicom files are stored
preproc_dir=[DME_dir '/Preproc'];
cd(preproc_dir);

% to define the subject list dynamically, we use the subject folder list in
% the preproc directory
delete .* % delete all invisible files
files = dir;
files = files(~ismember({files.name},{'.','..', 'scripts'})); % delete current and parent directory strings and the scripts dir
filenames = {files.name}; % from structure fils, only use the name
subdirs = filenames([files.isdir]); %only use those file names that correspond to folders
subjects = subdirs;

% define where to save the code
save_dir = [DME_dir '/scripts/GLM/glm1/'];
cd(save_dir);
    

for s = 1:length(subjects)
    
    SUBJ_ID = subjects{s};
    
    %load job file
    eval(['load DME_FirstLevel_glm1_' SUBJ_ID '.mat matlabbatch']);
    
    %run job file
    spm_jobman('run', matlabbatch);
    
end



