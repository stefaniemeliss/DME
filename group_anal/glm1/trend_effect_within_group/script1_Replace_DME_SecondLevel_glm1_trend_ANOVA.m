clear all;

% define DME dir
DME_dir = '/storage/shared/research/cinn/2018/MAGMOT/DME';

% add SPM dir
spm_dir=[DME_dir '/spm12'];
addpath(spm_dir);
spm fmri

% define where to save the code
save_dir = [DME_dir '/scripts/group_anal/glm1/trend_effect_within_group'];
cd(save_dir);

% load template
load DME_SecondLevel_glm1_trend_ANOVA.mat

% define name of models and contrast folders
contrast_dir = [DME_dir '/GLM/glm1/contrasts'];
d_contrast = {'SWWS_D' 'SW_D' 'WS_D' 'SWWS_Donly'};
m_contrast = {'SWWS_M' 'SW_M' 'WS_M' 'SWWS_Monly'};
e_contrast = {'SWWS_E' 'SW_E' 'WS_E' 'SWWS_Eonly'};

name_models = {'SWWS' 'SW' 'WS' 'SWWS_only'};

% define groups
group = {'control' 'reward' 'gambling'};


for g = 1:length(group) %iterates over all contrasts
    
    %%%start of the loop
    
    for i = 1:length(name_models) %iterates over all contrasts

        % define directories with contrast images
        data_dir_difficult = [contrast_dir '/' d_contrast{i} '/' group{g} '/'];
        data_dir_moderate = [contrast_dir '/' m_contrast{i} '/' group{g} '/'];
        data_dir_easy = [contrast_dir '/' e_contrast{i} '/' group{g} '/'];
        
        % create folder for SPM model estimation
        model_dir = [DME_dir '/GLM/glm1/2nd-level/trend_effect_within_group/' name_models{i} '/' group{g} '/'];
        mkdir(model_dir)
        
        
        cd([DME_dir '/GLM/glm1/2nd-level/trend_effect_within_group']);
        
        matlabbatch{1,1}.spm.stats.factorial_design.dir = {model_dir};
        
        %%%%%choose scans for cell(1) = difficult
        files = dir([data_dir_difficult '*.nii']);
        matlabbatch{1,1}.spm.stats.factorial_design.des.anova.icell(1).scans =  [];
        for f=1:length(files)
            matlabbatch{1,1}.spm.stats.factorial_design.des.anova.icell(1).scans{f,1} = [data_dir_difficult files(f).name ',1'];
        end
        
        %%%%%choose scans for cell(2) = moderate
        files = dir([data_dir_moderate '*.nii']);
        matlabbatch{1,1}.spm.stats.factorial_design.des.anova.icell(2).scans =  [];
        for f=1:length(files)
            matlabbatch{1,1}.spm.stats.factorial_design.des.anova.icell(2).scans{f,1} = [data_dir_moderate files(f).name ',1'];
        end
        
        %%%%%choose scans for cell(3) = easy
        files = dir([data_dir_easy '*.nii']); 
        matlabbatch{1,1}.spm.stats.factorial_design.des.anova.icell(3).scans =  [];
        for f=1:length(files)
            matlabbatch{1,1}.spm.stats.factorial_design.des.anova.icell(3).scans{f,1} = [data_dir_easy files(f).name ',1'];
        end
        
        cd(save_dir);
        
        eval(['save DME_SecondLevel_glm1_trend_ANOVA_' name_models{i} '_' group{g}  '.mat matlabbatch']);
    end
end