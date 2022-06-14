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

% remove subjects without variance in the ratings
% mot = KM13121604, KM14051501
% val = KM13121801, KM14051204
subjects = subjects(~ismember(subjects,{'KM13121604','KM14051501', 'KM13121801', 'KM14051204'}));

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
save_dir = [DME_dir '/scripts/contrast/parametric_modulation/pm_mot/'];
cd(save_dir);

for s = 1 :length(subjects)
    
    
    load DME_FirstLevel_Contrast_pm_mot.mat %random template
    
    SUBJ_ID = subjects{s};
    
    % set up model directory
    moddir = ['/storage/shared/research/cinn/2018/MAGMOT/DME/GLM/parametric_modulation/pm_mot/1st-level/' SUBJ_ID '/'];
    cd(moddir);
    
    % select spmmat
    matlabbatch{1,1}.spm.stats.con.spmmat{1,1} = [moddir 'SPM.mat'];
    
    % get in the DME_contrasts_pm_mot_*.mat file containing the object consess
    % consess includes names and weights for the contrasts on subject level
    cd(save_dir);
    
    % load in the correct file depending on subject 
    % contains an object 'consess' that has the information for all contrasts (name, weights, sessrep)
    if ismember(SUBJ_ID, subjects_full)
        load DME_contrasts_pm_mot_Full.mat
    elseif ismember(SUBJ_ID, subjects_noError)
        load DME_contrasts_pm_mot_NoError.mat
    elseif strcmp(subjects{s}, subject_special)
        load DME_contrasts_pm_mot_8_10.mat
    end
    
    
    matlabbatch{1,1}.spm.stats.con.consess = consess; %instead of matlabbatch{1}.spm.stats.con.consess{1}.tcon.name / {1}.tcon.weights / {1}.tcon.sessrep
    
        
    cd(save_dir);
    
    eval(['save DME_FirstLevel_Contrast_pm_mot_' SUBJ_ID '.mat matlabbatch']);
    
end


