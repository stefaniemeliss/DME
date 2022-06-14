clear all;

% define DME dir
DME_dir='/storage/shared/research/cinn/2018/MAGMOT/DME';

% add SPM dir
spm_dir=[DME_dir '/spm12'];
addpath(spm_dir);
spm fmri

% define where to save the code
save_dir = [DME_dir '/scripts/group_anal/glm1/trend_effect_within_group'];

% define name of models
name_models = {'SWWS' 'SW' 'WS' 'SWWS_only'};

% define groups
group = {'control' 'reward' 'gambling'};


for g = 1:length(group) 
        
    for i = 1:length(name_models) %iterates over all contrasts    
    cd(save_dir);

    eval(['load DME_SecondLevel_glm1_trend_ANOVA_' name_models{i} '_' group{g}  '.mat matlabbatch']);
    
    %run job file
    spm_jobman('run', matlabbatch);
    
    end
end



