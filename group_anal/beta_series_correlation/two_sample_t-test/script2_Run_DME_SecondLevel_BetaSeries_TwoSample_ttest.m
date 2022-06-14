clear all;

% define DME dir
DME_dir = '/storage/shared/research/cinn/2018/MAGMOT/DME';

% add SPM dir
spm_dir=[DME_dir '/spm12'];
addpath(spm_dir);
spm fmri

% define where to save the code
save_dir = [DME_dir '/scripts/group_anal/beta_series_correlation/two_sample_t-test'];
mkdir(save_dir);
cd(save_dir);

% define name of models and contrast folders
contrast_dir = [DME_dir '/GLM/beta_series_correlation/contrasts'];
contrast = {'SWWS_D' 'SWWS_Donly'};

sides={'left' 'right'};


% compute for all contrasts
for c=1:length(contrast)
    
    % compute for all sides
    for s = 1:length(sides)
        
        cd(save_dir);
        eval(['load DME_SecondLevel_BetaSeries_TwoSample_ttest' contrast{c} '_' sides{s} '_peak.mat matlabbatch']);
                
        %run job file
        spm_jobman('run', matlabbatch);
    end
end