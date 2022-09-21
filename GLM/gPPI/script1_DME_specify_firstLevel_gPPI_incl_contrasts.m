%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%% GENERALISED PSYCHO-PHYSIOLOGICAL INTERACTION (gPPI) ANALYSIS %%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% note: the files are saved in the same directory as the original 1st-Level GLM (i.e., glm1)
% because the directory is read out from the 1st-Level SPM.mat files


clear all;
clc;

% define DME dir
DME_dir='/storage/shared/research/cinn/2018/MAGMOT/DME';

% add SPM dir
spm_dir=[DME_dir '/spm12'];
addpath(spm_dir);

% add gPPI toolbox path
addpath([spm_dir '/toolbox/PPPI']);

% define hemispheres
sides={'left' 'right'};

% define directory to save contrasts in
con_dir = [DME_dir '/GLM/glm1/contrasts/'];

% define output contrasts
names_contrast = {'PPI_SWWS_Donly' 'PPI_SWWS_Monly'};

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

%% loop over all subjects %%

for s = 1:length(subjects)
    
    subject = subjects{s};
    
    % go into subject dir
    sub_dir = [DME_dir '/GLM/glm1/1st-level/' subject];
    cd(sub_dir);
    
    for i = 1:length(sides)
        
        % Set up the control param structure P which determines the run %
        
        P.subject=subject;
        P.directory=sub_dir;
        
        % determine VOI
        if strcmp(sides{i}, 'right')
            P.VOI=[DME_dir '/GLM/glm1/2nd-level/two_way_anova/SWWS/sphere5mm_right_peak_10_6_-10.nii'];
        else
            P.VOI=[DME_dir '/GLM/glm1/2nd-level/two_way_anova/SWWS/sphere5mm_left_peak_-8_6_-8.nii'];
        end
        
        P.Region=[sides{i} '_peak'];
        P.analysis='psy';
        P.method='cond';
        P.Estimate=1;
        P.contrast=0;
        P.extract='mean'; % changed from eigenvariate
        P.Tasks={'1' 'SW_D' 'SW_M' 'SW_E' 'WS_D' 'WS_M' 'WS_E'}; % conditions specified at 1st-Level (without the motion regressors)
        P.Weights=[];
        P.equalroi=1;
        P.FLmask=0;
        P.CompContrasts=1;
        
        P.Contrasts(1).name=[sides{i} '_peak_SWWS_Donly'];
        P.Contrasts(1).left={ 'SW_D' };
        P.Contrasts(1).right={ 'WS_D' };
        P.Contrasts(1).MinEvents=1;
        P.Contrasts(1).STAT='T';
        
        P.Contrasts(2).name=[sides{i} '_peak_SWWS_Monly'];
        P.Contrasts(2).left={ 'SW_M' };
        P.Contrasts(2).right={ 'WS_M' };
        P.Contrasts(2).MinEvents=1;
        P.Contrasts(2).STAT='T';
        
        % run PPPI: this executes 1st Level model estimation
        % PPPI(P);
        
        % clear variable
        clear P;
        
    end
    
     % list all contrast files in there
    cons = dir([sub_dir '/PPI*/con_*.nii']);
    contrast_files = {cons.name}; % from structure files, only use the name and folder
    contrast_dirs = {cons.folder};

        % loop over all contrast files
    for n=1:length(contrast_files)
                
        % select correct contrast name
        if contains(contrast_files{n}, 'SWWS_Donly')
            % create index for names_contrast variable
            n_con=n;
            name_contrast=names_contrast{1};
        else
            % create index for names_contrast variable
            name_contrast=names_contrast{2};
        end
        
        % create directories for each group (if necessary)
        cont_dir = [con_dir name_contrast '/control'];
        if ~exist(cont_dir, 'dir')
            mkdir(cont_dir)
        end
        reward_dir = [con_dir name_contrast '/reward'];
        if ~exist(reward_dir, 'dir')
            mkdir(reward_dir)
        end
        gambling_dir = [con_dir name_contrast '/gambling'];
        if ~exist(gambling_dir, 'dir')
            mkdir(gambling_dir)
        end
        
        % Prepare the input filename.
        thisFileName = contrast_files{n};
        inputFullFileName = fullfile(contrast_dirs{n}, contrast_files{n});
        
        % determine output folder depending on group
        if ismember(subjects{s}, control)
            outputFolder  = cont_dir;
        elseif ismember(subjects{s}, reward)
            outputFolder = reward_dir;
        elseif ismember(subjects{s}, gambling)
            outputFolder = gambling_dir;
        end
        
        % Prepare the new output filename.
        outputFullFileName = fullfile(outputFolder, contrast_files{n});
        
        % Do the copying and renaming all at once.
        copyfile(inputFullFileName, outputFullFileName);
        
    end

end



