%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% SWWS_XX FOLDER %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc;
clear all;

% define DME dir
DME_dir='/storage/shared/research/cinn/2018/MAGMOT/DME';

% % add SPM dir
% spm_dir=[DME_dir '/spm12'];
% addpath(spm_dir);
% spm('defaults','fMRI');
% spm_jobman('initcfg');

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


%%%%%%%%%%%%%%%%% new folders and subfolders %%%%%%%%%%%%%%%%%

base_dir = [DME_dir '/GLM/parametric_modulation/pm_val/'];

con_dir = [base_dir 'contrasts/'];
mkdir(con_dir);

first_level  = [base_dir '1st-level/'];


name_contrast = {'SW_mod' 'SWWS_mod' 'SWWS'};

% determine which subjects belong to which group
control = {'KM13121601' 'KM13121701' 'KM13121704'...
    'KM13121801' 'KM13121803' 'KM13121901'...
    'KM13122001' 'KM13122002' 'KM13122004' 'KM14051202'...
    'KM14051204' 'KM14051304' 'KM14051403'...
    'KM14051404' 'KM14051503' 'KM14051504' 'KM14051601'};

reward = {'KM13121602' 'KM13121604' 'KM13121702' 'KM13121703' 'KM13121802' 'KM13121804'...
    'KM13121902' 'KM13121903' 'KM13122003' 'KM14051201' 'KM14051203' 'KM14051301'...
    'KM14051302' 'KM14051401' 'KM14051402' 'KM14051501' 'KM14051502'};

gambling = {'KM14090101' 'KM14090102' 'KM14090103' 'KM14090104' 'KM14090201' 'KM14090202' 'KM14090301'...
    'KM14090302' 'KM14090303' 'KM14090304' 'KM14090401' 'KM14090402' 'KM14090403' 'KM14090501'...
    'KM14090502' 'KM14090503' 'KM14090504'};

%%%%%%%%%%%%%%%%% Copying and renaming files from subject to 'Contrasts' folder %%%%%%%%%%%%%%%%%



for s = 1:length(subjects)
    
    subjects{s} % print into console
    
    % go into subject folder
    sub_dir = [first_level subjects{s}];
    cd(sub_dir);
    
    % list all contrast files in there
    cons = dir('con_*.nii');
    contrast_files = {cons.name}; % from structure files, only use the name
    
    % loop over all contrast files
    for n=1:length(contrast_files)
        
        % create directories for each group (if necessary)
        cont_dir = [con_dir name_contrast{n} '/control'];
        if ~exist(cont_dir, 'dir')
            mkdir(cont_dir)
        end
        reward_dir = [con_dir name_contrast{n} '/reward'];
        if ~exist(reward_dir, 'dir')
            mkdir(reward_dir)
        end
        gambling_dir = [con_dir name_contrast{n} '/gambling'];
        if ~exist(gambling_dir, 'dir')
            mkdir(gambling_dir)
        end
        
        % Prepare the input filename.
        thisFileName = contrast_files{n};
        inputFullFileName = fullfile(sub_dir, thisFileName);
        
        % determine output folder depending on group
        if ismember(subjects{s}, control)
            outputFolder  = cont_dir;
        elseif ismember(subjects{s}, reward)
            outputFolder = reward_dir;
        elseif ismember(subjects{s}, gambling)
            outputFolder = gambling_dir;
        end
        
        % Prepare the new output filename.
        outputBaseFileName = [subjects{s} '_' thisFileName];
        outputFullFileName = fullfile(outputFolder, outputBaseFileName);
        
        % Do the copying and renaming all at once.
        copyfile(inputFullFileName, outputFullFileName);
        
    end
    
end

