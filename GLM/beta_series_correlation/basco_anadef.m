% betaseries analysis definition for BASCO
basco_path = fileparts(which('BASCO'));
AnaDef.Img                  = 'nii';
AnaDef.Img4D                = false;      % true: 4D Nifti
AnaDef.NumCond              = 6;          % number of conditions
AnaDef.Cond                 = { 'SW_D' , 'SW_M' , 'SW_E' , 'WS_D' , 'WS_M' , 'WS_E' }; % names of conditions
AnaDef.units                = 'secs';    % unit 'scans' or 'secs'
AnaDef.RT                   = 2.5;          % repetition time in seconds
AnaDef.fmri_t               = 16;
AnaDef.fmri_t0              = 8;
AnaDef.OutDir               = 'betaseries';  % output directory
AnaDef.Prefix               = 'swuaf';
AnaDef.OnsetModifier        = 0; % subtract this number from the onset-matrix (unit: scans)  <===== 4 files deleted and starting at 0 !!!

AnaDef.VoxelAnalysis        = true;  
AnaDef.ROIAnalysis          = false; % ROI level analysis (estimate model on ROIs for network analysis)
AnaDef.ROIDir               = fullfile(basco_path,'rois','AALROI90'); % select all ROIs in this directory
AnaDef.ROIPrefix            = 'MNI_';
AnaDef.ROINames             = fullfile(basco_path,'rois','AALROI90','AALROINAMES.txt'); % txt.-file containing ROI names
AnaDef.ROISummaryFunction   = 'mean'; % 'mean' or 'median'

AnaDef.HRFDERIVS            = [0 0];  % temporal and disperion derivatives: [0 0] or [1 0] or [1 1]

% regressors to include into design
AnaDef.MotionReg            = true;
AnaDef.GlobalMeanReg        = false;

% name of output-file (analysis objects)   %modified by JKL and SM (to replace
% basco_path with job_path)
AnaDef.Outfile              = fullfile(DME_dir,'GLM','beta_series_correlation', 'out_estimated.mat');

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


cSubj = 0; % subject counter

% define directory with data
data_dir = fullfile(DME_dir,'GLM','beta_series_correlation'); % directory containing all subject folders

% all subjects
for i=1:length(subjects)
    cSubj = cSubj+1;
    AnaDef.Subj{cSubj}.DataPath = fullfile(data_dir,subjects{i}); 
    AnaDef.Subj{cSubj}.NumRuns  = 2;
    AnaDef.Subj{cSubj}.RunDirs  = {'session1','session2'}; % modified by SM
    AnaDef.Subj{cSubj}.Onsets   = {'onsets_s1.txt','onsets_s2.txt'}; % modified by SM
    AnaDef.Subj{cSubj}.Duration = [1.5 1.5 1.5 1.5 1.5 1.5]; % modified by SM
end

% add number of subjects to AnaDef
AnaDef.NumSubjects = cSubj;

% change directory
cd(data_dir);