clear all;

% define DME dir
DME_dir = '/storage/shared/research/cinn/2018/MAGMOT/DME';

% add SPM dir
spm_dir=[DME_dir '/spm12'];
addpath(spm_dir);
spm fmri

% define where to save the code
save_dir = [DME_dir '/scripts/group_anal/parametric_modulation/pm_val/t-test'];
mkdir(save_dir);
cd(save_dir);

% load template
load DME_SecondLevel_pm_val_ttest.mat


% define name of models and contrast folders
contrast_dir = [DME_dir '/GLM/parametric_modulation/pm_val/contrasts'];
contrast = {'SW_mod' 'SWWS_mod' 'SWWS'}; 

% define groups
group = {'control' 'reward' 'gambling'};


for g = 1:length(group) %iterates over all contrasts
    
    %%%start of the loop
    
    for i = 1:length(contrast) %iterates over all contrasts

        % define directories with contrast images
        data_dir_group = [contrast_dir '/' contrast{i} '/' group{g} '/'];
        
        % create folder for SPM model estimation
        model_dir = [DME_dir '/GLM/parametric_modulation/pm_val/2nd-level/t-test/' contrast{i} '/' group{g} '/'];
        mkdir(model_dir)        
        matlabbatch{1,1}.spm.stats.factorial_design.dir = {model_dir};
        
        % choose contrast files
        files = dir([data_dir_group '*.nii']);
        matlabbatch{1, 1}.spm.stats.factorial_design.des.t1.scans = [];
        for f=1:length(files)
            matlabbatch{1, 1}.spm.stats.factorial_design.des.t1.scans{f,1} = [data_dir_group files(f).name ',1'];
        end        
        
        cd(save_dir);
        
        eval(['save DME_SecondLevel_pm_val_ttest_' contrast{i} '_' group{g}  '.mat matlabbatch']);
    end
end


