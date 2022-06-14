%% SET-UPS 

DME_dir='/storage/shared/research/cinn/2018/MAGMOT/DME';
cd(DME_dir);

% add SPM dir
spm_dir=[DME_dir '/spm12'];
addpath(spm_dir);

% add marsbar and basco toolbox to path
addpath([spm_dir '/toolbox/marsbar-0.45'])
addpath([spm_dir '/toolbox/BASCO'])

% 1) Start BASCO (within Matlab). The BASCO GUI should appear.
BASCO

%%  CREATE AnaDef STRUCTURE WITH ALL SPECIFICATIONS TO ESTIMATE THE MODEL ON FIRST LEVEL

% betaseries analysis definition for BASCO
basco_path = fileparts(which('BASCO'));
AnaDef.Img                  = 'nii';
AnaDef.Img4D                = false;      % true: 4D Nifti
AnaDef.NumCond              = 6;          % number of conditions
AnaDef.Cond                 = { 'SW_D' , 'SW_M' , 'SW_E' , 'WS_D' , 'WS_M' , 'WS_E' }; % names of conditions
AnaDef.units                = 'secs';    % unit 'scans' or 'secs'
AnaDef.RT                   = 2.5;          % repetition time in seconds
AnaDef.fmri_t               = 16;
AnaDef.fmri_t0   t           = 8;
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
AnaDef.Outfile              = fullfile(DME_dir,'GLM','beta_series_correlation', '1st-level', 'out_estimated.mat');

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
data_dir = fullfile(DME_dir,'GLM','beta_series_correlation', '1st-level'); % directory containing all subject folders

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

%% in a next step, model is run from GUI 

% Push the button 'Model specification and estimation' and select the file 'script2_DME_specify_firstLevel_betaseriescorrelation.m'. 
% BASCO now executes the analysis configuration script and performs the model specification and estimation. 
% All data is saved to the file specified in the analysis configuration script

%% seed-based functional connectivity

% 1) Push the button 'Seed ROI' to select a ROI (Marsbar) which is used as a seed region. Select spherical ROIs 
% ('sphere5mm_left_peak_-8_6_-8_roi.mat' & 'sphere5mm_right_peak_10_6_-10_roi.mat') from the glm1/two_way_anova/SWWS folder 
% Enter ‘sphere5mm_left_peak’ & 'sphere5mm_right_peak' as names

% 2) Use the button 'Show ROI' to view the ROI.

% 3) Now enter the conditions for the beta series in the edit box: 
% '1' for SW_D trials 
% '2' for SW_M trials 
% '3' for SW_E trials 
% '4' for WS_D trials 
% '5' for WS_M trials 
% '6' for WS_E trials 
% '1 2 3' for all SW trials
% '4 5 6' for all WS trials

% 4) Push the button ‘Mask’. This allows you to select a mask for the seed-based functional connectivity analysis. 
% A file browser opens. Go to the directory ‘masks’ and select the file 'spm12/toolbox/BASCO/masks/gm_mask_p03_roi.mat'

% 6) Press 'Compute correlation map' to start the analysis. 
% this creates a functional connectivity map in the subfolder 'betaseries' in the subject folder 'fcmap_sphere5mm_[left/right]_peak_[1-6].nii'
% which is also Fisher z transformd 'zfcmap_sphere5mm_[left/right]_peak_[1-6].nii'
