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


%%

% compute for all contrasts
for c=1:length(contrast)
    
    
    % compute for all sides
    for s = 1:length(sides)
        
        % load template
        load DME_SecondLevel_BetaSeries_TwoSample_ttest.mat
        
        % create folder for ouput
        spm_dir = [DME_dir '/GLM/beta_series_correlation/2nd-level/two_sample_t-test/' contrast{c} '/' sides{s} '_peak'];
        mkdir(spm_dir);
        
        matlabbatch{1}.spm.stats.factorial_design.dir = {spm_dir};
        
        % define data directory for control group
        data_dir_control=[contrast_dir '/'  contrast{c} '/control/'];        
        files = dir([data_dir_control 'KM*_' sides{s} '*.nii']);
        % add files to matlabbatch
        matlabbatch{1}.spm.stats.factorial_design.des.t2.scans1 =  [];
        for f=1:length(files)
            matlabbatch{1}.spm.stats.factorial_design.des.t2.scans1{f,1} = [data_dir_control files(f).name ',1'];
        end
        
        % define data directory for reward group
        data_dir_reward=[contrast_dir '/'  contrast{c} '/reward/'];        
        files = dir([data_dir_reward 'KM*_' sides{s} '*.nii']);
        % add files to matlabbatch
        matlabbatch{1}.spm.stats.factorial_design.des.t2.scans2 =  [];
        for f=1:length(files)
            matlabbatch{1}.spm.stats.factorial_design.des.t2.scans2{f,1} = [data_dir_reward files(f).name ',1'];
        end
                
        % save matlabbatch
        cd(save_dir);
        eval(['save DME_SecondLevel_BetaSeries_TwoSample_ttest' contrast{c} '_' sides{s} '_peak.mat matlabbatch']);
        
        
    end
    
end
