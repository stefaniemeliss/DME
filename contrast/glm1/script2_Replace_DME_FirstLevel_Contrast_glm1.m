clear all;

% define DME dir
DME_dir='/storage/shared/research/cinn/2018/MAGMOT/DME';

% add SPM dir
spm_dir=[DME_dir '/spm12'];
addpath(spm_dir);
spm fmri

% define path where dicom files are stored
preproc_dir=[DME_dir '/Preproc'];
cd(preproc_dir);


% to define the subject list dynamically, we use the subject folder list in
% the preproc directory
delete .* % delete all invisible files
files = dir;
files = files(~ismember({files.name},{'.','..', 'scripts'})); % delete current and parent directory strings and the scripts dir
filenames = {files.name}; % from structure fils, only use the name
subdirs = filenames([files.isdir]); %only use those file names that correspond to folders
subjects = subdirs;

subjects_noError = { 'KM13121602' 'KM13121604' 'KM13121703' 'KM13121704'...
    'KM13121802' 'KM13121803' 'KM13121804' 'KM13121902' 'KM13121903'...
    'KM13122001' 'KM13122003' 'KM14051201' 'KM14051202' 'KM14051203'...
    'KM14051301' 'KM14051302' 'KM14051304' 'KM14051402'...
    'KM14051404' 'KM14051502' 'KM14051503' 'KM14051504'...
    'KM14090102' 'KM14090103' 'KM14090201' 'KM14090202' 'KM14090301'...
    'KM14090302' 'KM14090303' 'KM14090304' 'KM14090503'...
    'KM14051204' 'KM14051501' 'KM14090104' 'KM14090401' };
subjects_full = {'KM13121601' 'KM13121701' 'KM13121702' 'KM13121901' 'KM13122002'...
    'KM14051403' 'KM14051601' 'KM14090101' 'KM14090403' 'KM14090502' 'KM14090504'...
    'KM13121801' 'KM13122004' 'KM14090402' 'KM14090501'};
subject_special =  {'KM14051401'};

% define where to save the code
save_dir = [DME_dir '/scripts/contrast/glm1/'];
cd(save_dir);

for s = 1 :length(subjects)
    
    
    load DME_FirstLevel_Contrast_glm1.mat %random template
    
    SUBJ_ID = subjects{s};
    
    % set up model directory
    moddir = ['/storage/shared/research/cinn/2018/MAGMOT/DME/GLM/glm1/1st-level/' SUBJ_ID '/'];
    cd(moddir);
    
    % select spmmat
    matlabbatch{1,1}.spm.stats.con.spmmat{1,1} = [moddir 'SPM.mat'];
    
    % get in the DME_contrasts_glm1_*.mat file containing the object consess
    % consess includes names and weights for the contrasts on subject level
    cd(save_dir);
    
    % load in the correct file depending on subject 
    % contains an object 'consess' that has the information for all contrasts (name, weights, sessrep)
    if ismember(SUBJ_ID, subjects_full)
        load DME_contrasts_glm1_Full.mat
    elseif ismember(SUBJ_ID, subjects_noError)
        load DME_contrasts_glm1_NoError.mat
    elseif strcmp(subjects{s}, subject_special)
        load DME_contrasts_glm1_9_11.mat
    end
    
    
    matlabbatch{1,1}.spm.stats.con.consess = consess; %instead of matlabbatch{1}.spm.stats.con.consess{1}.tcon.name / {1}.tcon.weights / {1}.tcon.sessrep
    
        
    cd(save_dir);
    
    eval(['save DME_FirstLevel_Contrast_glm1_' SUBJ_ID '.mat matlabbatch']);
    
end

% clear all;
% 
% DME_contrast_m1
% 
% %%% 10 10 and 10 11
% subjects = {'KM13121602' 'KM13121604' 'KM13121703' 'KM13121704'...
%     'KM13121802' 'KM13121803' 'KM13121804' 'KM13121902' 'KM13121903'...
%     'KM13122001' 'KM13122003' 'KM14051201' 'KM14051202' 'KM14051203'...
%     'KM14051301' 'KM14051302' 'KM14051304' 'KM14051402'...
%     'KM14051404' 'KM14051502' 'KM14051503' 'KM14051504'...
%     'KM14090102' 'KM14090103' 'KM14090201' 'KM14090202' 'KM14090301'...
%     'KM14090302' 'KM14090303' 'KM14090304' 'KM14090503'...
%     'KM14051204' 'KM14051501' 'KM14090104' 'KM14090401'};
% 
% 
% load Contrast_DME_m1.mat %random template
% 
% for s = 1 :length(subjects)
%     
%     SUBJ_ID = subjects{s};
%     
%     % set up model directory
%     moddir = ['/storage/shared/research/cinn/2018/MAGMOT/2017_DME/GLM/GLM1/1st-level/' SUBJ_ID '/'];
%     mkdir(moddir);
%     cd(moddir);
%     
%     % select spmmat
%     matlabbatch{1,1}.spm.stats.con.spmmat{1,1} = [moddir 'SPM.mat'];
%     
%     %get in the DME_Contrasts_m1_xx.mat file containing the object consess
%     save_dir = ['/storage/shared/research/cinn/2018/MAGMOT/2017_DME/SPM_SM/Contrast/Contrast_m1'];
%     cd(save_dir);
%     %load DME_contrasts_m1_9_11.mat
%     %load DME_contrasts_m1_Full.mat
%     load DME_contrasts_m1_NoError.mat %contains an object 'consess' that has the information for all 52 contrasts (name, weights, sessrep), created in DME_contrast_m1.m
%     
%     matlabbatch{1,1}.spm.stats.con.consess = consess; %instead of matlabbatch{1}.spm.stats.con.consess{1}.tcon.name / {1}.tcon.weights / {1}.tcon.sessrep
%     
%     
%     save_dir = ['/storage/shared/research/cinn/2018/MAGMOT/2017_DME/SPM_SM/Contrast/Contrast_m1'];
%     
%     cd(save_dir);
%     
%     eval(['save Contrast_DME_m1_' SUBJ_ID '.mat matlabbatch']);
%     
% end
% 
% 
% 
% clear all;
% 
% %%% 11 10 and 11 11
% subjects = {'KM13121601' 'KM13121701' 'KM13121702' 'KM13121901' 'KM13122002'...
%     'KM14051403' 'KM14051601' 'KM14090101' 'KM14090403' 'KM14090502' 'KM14090504'...
%     'KM13121801' 'KM13122004' 'KM14090402' 'KM14090501'};
% 
% 
% load Contrast_DME_m1.mat
% 
% for s = 1 :length(subjects)
%     
%     SUBJ_ID = subjects{s};
%     
%     % set up model directory
%     moddir = ['/storage/shared/research/cinn/2018/MAGMOT/2017_DME/GLM/GLM1/1st-level/' SUBJ_ID '/'];
%     mkdir(moddir);
%     cd(moddir);
%     
%     % assign spmmat
%     matlabbatch{1,1}.spm.stats.con.spmmat{1,1} = [moddir 'SPM.mat'];
%     
%     save_dir = ['/storage/shared/research/cinn/2018/MAGMOT/2017_DME/SPM_SM/Contrast/Contrast_m1'];
%     
%     cd(save_dir);
%     
%     %load DME_contrasts_m1_9_11.mat
%     load DME_contrasts_m1_Full.mat
%     %load DME_contrasts_m1_NoError.mat
%     
%     
%     matlabbatch{1,1}.spm.stats.con.consess = consess;
%     
%     
%     save_dir = ['/storage/shared/research/cinn/2018/MAGMOT/2017_DME/SPM_SM/Contrast/Contrast_m1'];
%     
%     cd(save_dir);
%     
%     eval(['save Contrast_DME_m1_' SUBJ_ID '.mat matlabbatch']);
%     
% end
% 
% 
% 
% 
% 
% clear all;
% 
% %%% 9 11
% subjects = {'KM14051401'};
% 
% 
% load Contrast_DME_m1.mat
% 
% for s = 1 :length(subjects)
%     
%     SUBJ_ID = subjects{s};
%     
%     % set up model directory
%     moddir = ['/storage/shared/research/cinn/2018/MAGMOT/2017_DME/GLM/GLM1/1st-level/' SUBJ_ID '/'];
%     mkdir(moddir);
%     cd(moddir);
%     
%     % assign spmmat
%     matlabbatch{1,1}.spm.stats.con.spmmat{1,1} = [moddir 'SPM.mat'];
%     
%     save_dir = ['/storage/shared/research/cinn/2018/MAGMOT/2017_DME/SPM_SM/Contrast/Contrast_m1'];
%     
%     cd(save_dir);
%     
%     load DME_contrasts_m1_9_11.mat
%     %load DME_contrasts_m1_Full.mat
%     %load DME_contrasts_m1_NoError.mat
%     
%     
%     matlabbatch{1,1}.spm.stats.con.consess = consess;
%     
%     
%     save_dir = ['/storage/shared/research/cinn/2018/MAGMOT/2017_DME/SPM_SM/Contrast/Contrast_m1'];
%     
%     cd(save_dir);
%     
%     eval(['save Contrast_DME_m1_' SUBJ_ID '.mat matlabbatch']);
%     
% end
% 
