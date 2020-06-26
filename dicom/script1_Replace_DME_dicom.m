clear all;

% define DME dir
DME_dir='/storage/shared/research/cinn/2018/MAGMOT/DME';

% add SPM dir
spm_dir=[DME_dir '/spm12'];
addpath(spm_dir);
spm fmri

% define where to save the code
save_dir = [DME_dir '/scripts/dicom/'];


% define path where dicom files are stored
dicom_dir=[DME_dir '/Dicom'];
cd(dicom_dir);


% to define the subject list dynamically, we use the subject folder list in
% the dicom directory
delete .* % delete all invisible files
files = dir;
files = files(~ismember({files.name},{'.','..', 'scripts'})); % delete current and parent directory strings and the scripts dir
filenames = {files.name}; % from structure fils, only use the name
subdirs = filenames([files.isdir]); %only use those file names that correspond to folders
subjects = subdirs;

% load in matlab batch
load DME_dicom.mat

for s = 1 :length(subjects)
    
    % define directories for each subject
    data_dir = [dicom_dir '/' subjects{s} '/'];
    func_dir = [DME_dir '/Preproc/' subjects{s} '/func/'];
    anat_dir = [DME_dir '/Preproc/' subjects{s} '/anat/'];
    
    % create folder where the nii files will be saved
    mkdir(func_dir);
    mkdir(anat_dir);
    
    % define dicom files
    files = [];
    files = dir([data_dir '/*']);
    files = files(~ismember({files.name},{'.','..'})); % delete current and parent directory strings and the scripts dir
    
    % define matlab batch file %
    
    matlabbatch{1,1}.spm.util.import.dicom.data = []; % dicom import files
    for f = 1:length(files)
        matlabbatch{1,1}.spm.util.import.dicom.data{f, 1} = [data_dir files(f).name];
    end
    
    matlabbatch{1,1}.spm.util.import.dicom.outdir{1,1} = [func_dir]; % nii output dir
    
    matlabbatch{1,2}.cfg_basicio.file_dir.file_ops.file_fplist.dir{1} = [func_dir]; % file selector to grap structural file in func_dir
    
    matlabbatch{1,3}.cfg_basicio.file_dir.file_ops.file_move.action.moveto{1} = [anat_dir]; % move structural file to anat_dir
    
    
    % save batch for each subject
    cd(save_dir);
    eval(['save DME_Dicom_' subjects{s} '.mat matlabbatch']);
end
