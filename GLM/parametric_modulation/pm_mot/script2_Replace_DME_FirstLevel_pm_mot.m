clear all;

% define DME dir
DME_dir='/storage/shared/research/cinn/2018/MAGMOT/DME';

% add SPM dir
spm_dir=[DME_dir '/spm12'];
addpath(spm_dir);
spm fmri

% define where to save the code
save_dir = [DME_dir '/scripts/GLM/parametric_modulation/pm_mot/'];

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

% remove subjects without variance in the ratings
% mot = KM13121604, KM14051501
% val = KM13121801, KM14051204
subjects = subjects(~ismember(subjects,{'KM13121604','KM14051501', 'KM13121801', 'KM14051204'}));


%% loop over subjects
for s = 1:length(subjects)
    
    % load matlab batch
    cd(save_dir)
    load DME_FirstLevel_pm_mot.mat
    % this batch file includes the fMRI model specification for both sessions using the multiple
    % conditions option
    
    
    % define folder nummer depending on subject
    if strcmp(subjects{s}, 'KM13121601')
        folder_num = {'08' '10'};
    elseif strcmp(subjects{s}, 'KM13121604')
        folder_num = {'04' '07'};
    elseif strcmp(subjects{s}, 'KM13121703')
        folder_num = {'06' '08'};
    elseif strcmp(subjects{s}, 'KM14051502')
        folder_num = {'04' '10'};
    else
        folder_num = {'04' '06'};
    end
    
    % define SUBJ_ID
    SUBJ_ID = subjects{s};
    
    % set up model directory
    moddir = [DME_dir '/GLM/parametric_modulation/pm_mot/1st-level/' SUBJ_ID '/'];
    mkdir(moddir);
    cd(moddir);
    % specify data_dir
    data_dir = [DME_dir '/Preproc/' SUBJ_ID '/func/'];
    
    % specify directory in the batch
    matlabbatch{1,1}.spm.stats.fmri_spec.dir{1,1} = moddir;
    
    for i = 1:2 % for both sessions
        
        % add preprocessed files to the batch
        files = dir([data_dir 'swuaf' SUBJ_ID '-00' folder_num{i} '-*-*-01.nii']);
        matlabbatch{1,1}.spm.stats.fmri_spec.sess(1,i).scans =  [];
        for f=1:length(files)
            matlabbatch{1,1}.spm.stats.fmri_spec.sess(1,i).scans{f,1} =  [data_dir files(f).name ',1'];
        end
        
        %onset info (multiple conditions
        matlabbatch{1,1}.spm.stats.fmri_spec.sess(1,i).multi{1,1} = [DME_dir '/scripts/GLM/parametric_modulation/pm_mot/Regress_pm_mot/' SUBJ_ID '_regress_pm_mot_s' num2str(i) '.mat'];
        
        % motion parameters
        matlabbatch{1,1}.spm.stats.fmri_spec.sess(1,i).multi_reg{1,1} = [data_dir 'rp_af' SUBJ_ID '-00' folder_num{i} '-00004-000004-01.txt'];
        
    end
    
    % change directory and SPM.mat for estimation
    cd(save_dir);
    eval(['save DME_FirstLevel_pm_mot_' SUBJ_ID '.mat matlabbatch']);
    
end