clear all;

% define DME dir
DME_dir = '/storage/shared/research/cinn/2018/MAGMOT/DME';

% add SPM dir
spm_dir=[DME_dir '/spm12'];
addpath(spm_dir);
spm fmri

% define where to save the code
save_dir = [DME_dir '/scripts/group_anal/gPPI/two_sample_t-test'];
cd(save_dir);

% define name of models and contrast folders
contrast = {'SWWS_Donly' 'SWWS_Monly'};

sides={'left' 'right'};


% compute for all contrasts
for c=1:length(contrast)
    
    % compute for all sides
    for s = 1:length(sides)
        
        cd(save_dir);
        eval(['load DME_SecondLevel_gPPI_TwoSample_ttest_' contrast{c} '_' sides{s} '_peak.mat matlabbatch']);
                
        %run job file
        spm_jobman('run', matlabbatch);
    end
end