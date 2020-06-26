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

% define where to load and save the code
load_dir = [DME_dir '/scripts/GLM/glm1/Regress_glm1/'];
save_dir = [DME_dir '/scripts/contrast/glm1/'];

for s = 1:length(subjects)
    
    cd(load_dir);
    
    % get information on regressors for first session
    eval(['load ' subjects{s} '_regress_glm1_s1.mat']);
    A = [];
    A = names
    
    % get information on regressors for second session
    eval(['load ' subjects{s} '_regress_glm1_s2.mat']);
    B = [];
    B = names
   
    
    reg = [];
    reg = [subjects{s}, A,B];
    
    temp = [];
    temp = reg;
    
    reg_names(s,1:length(reg)) = temp;
   
end


 cd(save_dir);
 eval(['save DME_names_regress_glm1.mat reg_names']);