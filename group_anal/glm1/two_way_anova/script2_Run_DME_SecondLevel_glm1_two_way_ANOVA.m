clear all;

% define DME dir
DME_dir='/storage/shared/research/cinn/2018/MAGMOT/DME';

% add SPM dir
spm_dir=[DME_dir '/spm12'];
addpath(spm_dir);
spm fmri

% define where to save the code
load_dir = [DME_dir '/scripts/group_anal/glm1/two_way_anova'];
cd(load_dir);

name_models = {'SWWS' 'SW' 'WS' 'SWWS_only'};



for n= 1:length(name_models)

    % run job file
    eval(['load DME_SecondLevel_glm1_two_way_ANOVA_' name_models{n} '.mat matlabbatch']);
    spm_jobman('run', matlabbatch);    
    
    
end


