clear all;

% define DME dir
DME_dir='/storage/shared/research/cinn/2018/MAGMOT/DME';

% add SPM dir
spm_dir=[DME_dir '/spm12'];
addpath(spm_dir);
spm fmri

% define where to save the code
save_dir = [DME_dir '/scripts/group_anal/glm1/t_tests'];
cd(save_dir);

% load template
load DME_SecondLevel_glm1_t_tests.mat

% define name of models and contrast folders
contrast_dir = [DME_dir '/GLM/glm1/contrasts'];

name_contrast = {'SWWS_D' 'SWWS_M' 'SWWS_E'};

% define groups
groups = {'control' 'reward' 'gambling'};

%%%%%%%%% start of the loop iterating over the the groups %%%%%%%%%

for g = 1:length(groups)
    
    
    %%%%%%%%% start of the loop iterating over the the models %%%%%%%%%
    
    for n = 1:length(name_contrast)
        
        % define directory where to save the contrast files
        data_dir = [contrast_dir '/' name_contrast{n} '/' groups{g} '/'];        
        
        % create folder where SPM.mat file will be saved
        mkdir([DME_dir '/GLM/glm1/2nd-level/t_tests/' name_contrast{n} '/' groups{g} '/']);
        matlabbatch{1,1}.spm.stats.factorial_design.dir = {[DME_dir '/GLM/glm1/2nd-level/t_tests/' name_contrast{n} '/' groups{g} '/']};
        
        % fill in the contrast files
        matlabbatch{1,1}.spm.stats.factorial_design.des.t1.scans = [];
        files = dir([data_dir '*.nii']);
        for f=1:length(files)
            matlabbatch{1,1}.spm.stats.factorial_design.des.t1.scans{f,1} = [data_dir files(f).name ',1'];
        end

        % save batch file
        cd(save_dir);
        
        eval(['save DME_SecondLevel_glm1_t_tests_' name_contrast{n} '_' groups{g} '.mat matlabbatch']);
    end
    
end


