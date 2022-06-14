clear all;

% define DME dir
DME_dir = '/storage/shared/research/cinn/2018/MAGMOT/DME';

% add SPM dir
spm_dir=[DME_dir '/spm12'];
addpath(spm_dir);
spm fmri

% define where to save the code
save_dir = [DME_dir '/scripts/group_anal/parametric_modulation/pm_val/t-test'];
cd(save_dir);

% define name of models and contrast folders
contrast_dir = [DME_dir '/GLM/parametric_modulation/pm_val/contrasts'];
contrast = {'SW_mod' 'SWWS_mod' 'SWWS'};

% define groups
group = {'control' 'reward' 'gambling'};


for g = 1:length(group) %iterates over all contrasts
    
    %%%start of the loop
    
    for i = 1:length(contrast) %iterates over all contrasts
        
        cd(save_dir);
        
        eval(['load DME_SecondLevel_pm_val_ttest_' contrast{i} '_' group{g}  '.mat matlabbatch']);
        
        %run job file
        spm_jobman('run', matlabbatch);
    end
end





