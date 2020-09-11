clear all;

% define DME dir
DME_dir='/storage/shared/research/cinn/2018/MAGMOT/DME';

% add SPM dir
spm_dir=[DME_dir '/spm12'];
addpath(spm_dir);
spm fmri

% define where to save the code
save_dir = [DME_dir '/scripts/group_anal/glm1/two_way_anova'];
cd(save_dir);

% load template
load DME_SecondLevel_glm1_two_way_ANOVA.mat

% define name of models and contrast folders
contrast_dir = [DME_dir '/GLM/glm1/contrasts'];
d_contrast = {'SWWS_D' 'SW_D' 'WS_D' 'SWWS_Donly'};
m_contrast = {'SWWS_M' 'SW_M' 'WS_M' 'SWWS_Monly'};
e_contrast = {'SWWS_E' 'SW_E' 'WS_E' 'SWWS_Eonly'};

name_models = {'SWWS' 'SW' 'WS' 'SWWS_only'};


%%%%%%%%% start of the loop iterating over the the models %%%%%%%%%

for n = 1:length(name_models) 
    
    % define directory where to save the contrast files
    data_dir_d_control = [contrast_dir '/' d_contrast{n} '/control/'];
    data_dir_d_reward = [contrast_dir '/' d_contrast{n} '/reward/'];
    data_dir_d_gambling = [contrast_dir '/' d_contrast{n} '/gambling/'];
    data_dir_m_control = [contrast_dir '/' m_contrast{n} '/control/'];
    data_dir_m_reward = [contrast_dir '/' m_contrast{n} '/reward/'];
    data_dir_m_gambling = [contrast_dir '/' m_contrast{n} '/gambling/'];
    data_dir_e_control = [contrast_dir '/' e_contrast{n} '/control/'];
    data_dir_e_reward = [contrast_dir '/' e_contrast{n} '/reward/'];
    data_dir_e_gambling = [contrast_dir '/' e_contrast{n} '/gambling/'];
    
    
    % create folder where SPM.mat file will be saved
    mkdir([DME_dir '/GLM/glm1/2nd-level/two_way_anova/' name_models{n} '/']);
    matlabbatch{1,1}.spm.stats.factorial_design.dir = {[DME_dir '/GLM/glm1/2nd-level/two_way_anova/' name_models{n} '/']};
    
    % fill in the contrast files into each cell
    
    % cell [1 1] = Control difficult
    matlabbatch{1,1}.spm.stats.factorial_design.des.fd.icell(1).scans = [];
    files = dir([data_dir_d_control '*.nii']);
    for f=1:length(files)
        matlabbatch{1,1}.spm.stats.factorial_design.des.fd.icell(1).scans{f,1} = [data_dir_d_control files(f).name ',1'];
    end
    
    % cell [1 2] = Control moderate
    matlabbatch{1,1}.spm.stats.factorial_design.des.fd.icell(2).scans = [];
    files = dir([data_dir_m_control '*.nii']);
    for f=1:length(files)
        matlabbatch{1,1}.spm.stats.factorial_design.des.fd.icell(2).scans{f,1} = [data_dir_m_control files(f).name ',1'];
    end
    
    % cell [1 3] = Control easy
    matlabbatch{1,1}.spm.stats.factorial_design.des.fd.icell(3).scans = [];
    files = dir([data_dir_e_control '*.nii']);
    for f=1:length(files)
        matlabbatch{1,1}.spm.stats.factorial_design.des.fd.icell(3).scans{f,1} = [data_dir_e_control files(f).name ',1'];
    end
    
    % cell [2 1] = Reward difficult
    matlabbatch{1,1}.spm.stats.factorial_design.des.fd.icell(4).scans = [];
    files = dir([data_dir_d_reward '*.nii']);
    for f=1:length(files)
        matlabbatch{1,1}.spm.stats.factorial_design.des.fd.icell(4).scans{f,1} = [data_dir_d_reward files(f).name ',1'];
    end
    
    % cell [2 2] = Reward moderate
    matlabbatch{1,1}.spm.stats.factorial_design.des.fd.icell(5).scans = [];
    files = dir([data_dir_m_reward '*.nii']);
    for f=1:length(files)
        matlabbatch{1,1}.spm.stats.factorial_design.des.fd.icell(5).scans{f,1} = [data_dir_m_reward files(f).name ',1'];
    end
    
    % cell [2 3] = Reward easy
    matlabbatch{1,1}.spm.stats.factorial_design.des.fd.icell(6).scans = [];
    files = dir([data_dir_e_reward '*.nii']);
    for f=1:length(files)
        matlabbatch{1,1}.spm.stats.factorial_design.des.fd.icell(6).scans{f,1} = [data_dir_e_reward files(f).name ',1'];
    end
    % cell [3 1] = Gambling difficult
    matlabbatch{1,1}.spm.stats.factorial_design.des.fd.icell(7).scans = [];
    files = dir([data_dir_d_gambling '*.nii']);
    for f=1:length(files)
        matlabbatch{1,1}.spm.stats.factorial_design.des.fd.icell(7).scans{f,1} = [data_dir_d_gambling files(f).name ',1'];
    end
    
    % cell [3 2] = Gambling moderate
    matlabbatch{1,1}.spm.stats.factorial_design.des.fd.icell(8).scans = [];
    files = dir([data_dir_m_gambling '*.nii']);
    for f=1:length(files)
        matlabbatch{1,1}.spm.stats.factorial_design.des.fd.icell(8).scans{f,1} = [data_dir_m_gambling files(f).name ',1'];
    end
    
    % cell [3 3] = Gambling easy
    matlabbatch{1,1}.spm.stats.factorial_design.des.fd.icell(9).scans = [];
    files = dir([data_dir_e_gambling '*.nii']);
    for f=1:length(files)
        matlabbatch{1,1}.spm.stats.factorial_design.des.fd.icell(9).scans{f,1} = [data_dir_e_gambling files(f).name ',1'];
    end
    
    % save batch file
    cd(save_dir);
    
    eval(['save DME_SecondLevel_glm1_two_way_ANOVA_' name_models{n} '.mat matlabbatch']);
end


