clear all;

% define DME dir
DME_dir='/storage/shared/research/cinn/2018/MAGMOT/DME';

% add SPM dir
spm_dir=[DME_dir '/spm12'];
addpath(spm_dir);
spm fmri

% define where to save the code
load_dir = [DME_dir '/scripts/group_anal/glm1/t_tests'];
cd(load_dir);

name_contrast = {'SWWS_D' 'SWWS_M' 'SWWS_E'};

% define groups
groups = {'control' 'reward' 'gambling'};

%%%%%%%%% start of the loop iterating over the the groups %%%%%%%%%

for g = 1:length(groups)
    
    
    %%%%%%%%% start of the loop iterating over the the models %%%%%%%%%
    
    for n = 1:length(name_contrast)

    % run job file
    eval(['load DME_SecondLevel_glm1_t_tests_' name_contrast{n} '_' groups{g} '.mat matlabbatch']);
    spm_jobman('run', matlabbatch);
    
    end
    
    
end


