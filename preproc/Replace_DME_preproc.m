clear all;

% define DME dir
DME_dir='/storage/shared/research/cinn/2018/MAGMOT/DME';

% add SPM dir
spm_dir=[DME_dir '/spm12'];
addpath(spm_dir);
spm fmri

% define where to save the code
save_dir = [DME_dir '/scripts/preproc/'];


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

%% loop over subjects
for s = 1:length(subjects)
    
    % load matlab batch
    cd(save_dir)
    load DME_Preproc.mat
    % this batch file represents the SPM default (/spm12/batches/preproc_fmri.m)
    % slice timing correction is performed before motion correction due to
    % interleaved acquition (TR=2.5, nslices=42, slice order = 2 4 6...42 1 3 5...41, reference slice = 42)
    % number of sessions is set to 2

    
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
    
    % define data dir for each subject
    data_dir = [DME_dir '/Preproc/' subjects{s} '/func/'];
    anat_dir = [DME_dir '/Preproc/' subjects{s} '/anat/'];
    
    % determine matlabbatch %
    cd(data_dir);
    % functional files %

%     matlabbatch{1,1}.spm.spatial.realignunwarp.data(1).scans = [];
%     files = dir(['f' subjects{s} '-00' folder_num{1} '-*.nii']);  % input raw nii files sess 1
%     for f=4:length(files) % disregard the first three volumes
%         matlabbatch{1,1}.spm.spatial.realignunwarp.data(1).scans{f-3,1} = [data_dir files(f).name ',1'];
%     end
    
    matlabbatch{1,1}.spm.temporal.st.scans = [];
    files = dir(['f' subjects{s} '-00' folder_num{1} '-*.nii']);  % input raw nii files sess 1
    for f=4:length(files) % disregard the first three volumes
        matlabbatch{1,1}.spm.temporal.st.scans{1,1}{f-3,1} = [data_dir files(f).name ',1'];
    end
    
    
%     matlabbatch{1,1}.spm.spatial.realignunwarp.data(2).scans = [];
%     
%     files = dir(['f' subjects{s} '-00' folder_num{2} '-*.nii']); % input raw nii files sess 2
%     for f=4:length(files) % disregard the first three volumes
%         matlabbatch{1,1}.spm.spatial.realignunwarp.data(2).scans{f-3,1} = [data_dir files(f).name ',1'];
%     end
    
    files = dir(['f' subjects{s} '-00' folder_num{2} '-*.nii']);  % input raw nii files sess 1
    for f=4:length(files) % disregard the first three volumes
        matlabbatch{1,1}.spm.temporal.st.scans{1,2}{f-3,1} = [data_dir files(f).name ',1'];
    end
    
    % anatomoical file
    cd(anat_dir)
    anat = dir(['s' subjects{s} '-0002-00001-000192-01.nii']);
    
    matlabbatch{1,3}.spm.spatial.preproc.channel.vols = [];
    
    for a=1:length(anat)
        matlabbatch{1,3}.spm.spatial.preproc.channel.vols{1} = [anat_dir, anat(a).name ',1' ];
    end
    
    
    % save matlab batch
    cd(save_dir);
    eval(['save DME_Preproc_' subjects{s} '.mat matlabbatch']);
    
end




% %%
% clc;
% clear all;
% 
% subjects = { 'KM13121602' 'KM13121701' 'KM13121702' 'KM13121704'...
%     'KM13121801' 'KM13121802' 'KM13121803' 'KM13121804' 'KM13121901' 'KM13121902' 'KM13121903'...
%     'KM13122001' 'KM13122002' 'KM13122003' 'KM13122004' 'KM14051201' 'KM14051202' 'KM14051203'...
%     'KM14051204' 'KM14051301' 'KM14051302' 'KM14051304' 'KM14051401' 'KM14051402' 'KM14051403'...
%     'KM14051404' 'KM14051501' 'KM14051503' 'KM14051504' 'KM14051601'...
%     'KM14090101' 'KM14090102' 'KM14090103' 'KM14090104' 'KM14090201' 'KM14090202' 'KM14090301'...
%     'KM14090302' 'KM14090303' 'KM14090304' 'KM14090401' 'KM14090402' 'KM14090403' 'KM14090501'...
%     'KM14090502' 'KM14090503' 'KM14090504'};
% folder_num = {'04' '06'};
% 
% 
% load Preproc_DME.mat
% 
% for s = 1:length(subjects)
%     
%     data_dir = ['/Volumes/DATA UOR/2017_DME/Preproc_SM/' subjects{s} '/func/'];
%     anat_dir = ['/Volumes/DATA UOR/2017_DME/Preproc_SM/' subjects{s} '/anat/'];
%     save_dir = ['/Volumes/DATA UOR/2017_DME/SPM_SM/Preproc/'];
%     
%     cd(data_dir);
%     
%     matlabbatch{1,1}.spm.spatial.realignunwarp.data(1).scans = [];
%     
%     
%     files = dir(['f' subjects{s} '-00' folder_num{1} '-*.nii']);
%     for f=4:length(files)
%         matlabbatch{1,1}.spm.spatial.realignunwarp.data(1).scans{f-3,1} = [data_dir files(f).name ',1'];
%     end
%     
%     matlabbatch{1,1}.spm.spatial.realignunwarp.data(2).scans = [];
%     
%     files = dir(['f' subjects{s} '-00' folder_num{2} '-*.nii']);
%     for f=4:length(files)
%         matlabbatch{1,1}.spm.spatial.realignunwarp.data(2).scans{f-3,1} = [data_dir files(f).name ',1'];
%     end
%     
%     cd(anat_dir)
%     anat = dir(['s' subjects{s} '-0002-00001-000192-01.nii']);
%     
%     matlabbatch{1,2}.spm.spatial.preproc.channel.vols = [];
%     
%     for a=1:length(anat)
%         matlabbatch{1,2}.spm.spatial.preproc.channel.vols{1} = [anat_dir, anat(a).name ',1' ];
%     end
%     
%     
%     
%     cd(save_dir);
%     eval(['save Preproc_DME_' subjects{s} '.mat matlabbatch']);
%     
%     
% end
% 
% 
% 
% 
% 
% clear all;
% %
% subjects = {'KM13121601'};
% folder_num = {'08' '10'};
% 
% 
% 
% load Preproc_DME.mat
% 
% for s = 1:length(subjects)
%     
%     
%     data_dir = ['/Volumes/DATA UOR/2017_DME/Preproc_SM/' subjects{s} '/func/'];
%     anat_dir = ['/Volumes/DATA UOR/2017_DME/Preproc_SM/' subjects{s} '/anat/'];
%     save_dir = ['/Volumes/DATA UOR/2017_DME/SPM_SM/Preproc/'];
%     
%     cd(data_dir);
%     
%     matlabbatch{1,1}.spm.spatial.realignunwarp.data(1).scans = [];
%     
%     
%     files = dir(['f' subjects{s} '-00' folder_num{1} '-*.nii']);
%     for f=4:length(files)
%         matlabbatch{1,1}.spm.spatial.realignunwarp.data(1).scans{f-3,1} = [data_dir files(f).name ',1'];
%     end
%     
%     matlabbatch{1,1}.spm.spatial.realignunwarp.data(2).scans = [];
%     
%     files = dir(['f' subjects{s} '-00' folder_num{2} '-*.nii']);
%     for f=4:length(files)
%         matlabbatch{1,1}.spm.spatial.realignunwarp.data(2).scans{f-3,1} = [data_dir files(f).name ',1'];
%     end
%     
%     cd(anat_dir)
%     anat = dir(['s' subjects{s} '-0002-00001-000192-01.nii']);
%     
%     matlabbatch{1,2}.spm.spatial.preproc.channel.vols = [];
%     
%     for a=1:length(anat)
%         matlabbatch{1,2}.spm.spatial.preproc.channel.vols{1} = [anat_dir, anat(a).name ',1' ];
%     end
%     
%     
%     
%     cd(save_dir);
%     eval(['save Preproc_DME_' subjects{s} '.mat matlabbatch']);
%     
% end
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% clear all;
% subjects = {'KM13121604'};
% folder_num = {'04' '07'};
% 
% 
% load Preproc_DME.mat
% 
% for s = 1:length(subjects)
%     
%     
%     data_dir = ['/Volumes/DATA UOR/2017_DME/Preproc_SM/' subjects{s} '/func/'];
%     anat_dir = ['/Volumes/DATA UOR/2017_DME/Preproc_SM/' subjects{s} '/anat/'];
%     save_dir = ['/Volumes/DATA UOR/2017_DME/SPM_SM/Preproc/'];
%     
%     cd(data_dir);
%     
%     matlabbatch{1,1}.spm.spatial.realignunwarp.data(1).scans = [];
%     
%     
%     files = dir(['f' subjects{s} '-00' folder_num{1} '-*.nii']);
%     for f=4:length(files)
%         matlabbatch{1,1}.spm.spatial.realignunwarp.data(1).scans{f-3,1} = [data_dir files(f).name ',1'];
%     end
%     
%     matlabbatch{1,1}.spm.spatial.realignunwarp.data(2).scans = [];
%     
%     files = dir(['f' subjects{s} '-00' folder_num{2} '-*.nii']);
%     for f=4:length(files)
%         matlabbatch{1,1}.spm.spatial.realignunwarp.data(2).scans{f-3,1} = [data_dir files(f).name ',1'];
%     end
%     
%     cd(anat_dir)
%     anat = dir(['s' subjects{s} '-0002-00001-000192-01.nii']);
%     
%     matlabbatch{1,2}.spm.spatial.preproc.channel.vols = [];
%     
%     for a=1:length(anat)
%         matlabbatch{1,2}.spm.spatial.preproc.channel.vols{1} = [anat_dir, anat(a).name ',1' ];
%     end
%     
%     
%     
%     cd(save_dir);
%     eval(['save Preproc_DME_' subjects{s} '.mat matlabbatch']);
%     
%     
% end
% 
% 
% 
% 
% clear all;
% subjects = {'KM13121703'};
% folder_num = {'06' '08'};
% 
% 
% load Preproc_DME.mat
% 
% for s = 1:length(subjects)
%     
%     
%     data_dir = ['/Volumes/DATA UOR/2017_DME/Preproc_SM/' subjects{s} '/func/'];
%     anat_dir = ['/Volumes/DATA UOR/2017_DME/Preproc_SM/' subjects{s} '/anat/'];
%     save_dir = ['/Volumes/DATA UOR/2017_DME/SPM_SM/Preproc/'];
%     
%     cd(data_dir);
%     
%     matlabbatch{1,1}.spm.spatial.realignunwarp.data(1).scans = [];
%     
%     
%     files = dir(['f' subjects{s} '-00' folder_num{1} '-*.nii']);
%     for f=4:length(files)
%         matlabbatch{1,1}.spm.spatial.realignunwarp.data(1).scans{f-3,1} = [data_dir files(f).name ',1'];
%     end
%     
%     matlabbatch{1,1}.spm.spatial.realignunwarp.data(2).scans = [];
%     
%     files = dir(['f' subjects{s} '-00' folder_num{2} '-*.nii']);
%     for f=4:length(files)
%         matlabbatch{1,1}.spm.spatial.realignunwarp.data(2).scans{f-3,1} = [data_dir files(f).name ',1'];
%     end
%     
%     cd(anat_dir)
%     anat = dir(['s' subjects{s} '-0002-00001-000192-01.nii']);
%     
%     matlabbatch{1,2}.spm.spatial.preproc.channel.vols = [];
%     
%     for a=1:length(anat)
%         matlabbatch{1,2}.spm.spatial.preproc.channel.vols{1} = [anat_dir, anat(a).name ',1' ];
%     end
%     
%     
%     
%     cd(save_dir);
%     eval(['save Preproc_DME_' subjects{s} '.mat matlabbatch']);
%     
%     
% end
% 
% 
% clear all;
% subjects = {'KM14051502' };
% folder_num = {'04' '10'};
% 
% 
% load Preproc_DME.mat
% 
% for s = 1:length(subjects)
%     
%     data_dir = ['/Volumes/DATA UOR/2017_DME/Preproc_SM/' subjects{s} '/func/'];
%     anat_dir = ['/Volumes/DATA UOR/2017_DME/Preproc_SM/' subjects{s} '/anat/'];
%     save_dir = ['/Volumes/DATA UOR/2017_DME/SPM_SM/Preproc/'];
%     
%     cd(data_dir);
%     
%     matlabbatch{1,1}.spm.spatial.realignunwarp.data(1).scans = [];
%     
%     
%     files = dir(['f' subjects{s} '-00' folder_num{1} '-*.nii']);
%     for f=4:length(files)
%         matlabbatch{1,1}.spm.spatial.realignunwarp.data(1).scans{f-3,1} = [data_dir files(f).name ',1'];
%     end
%     
%     matlabbatch{1,1}.spm.spatial.realignunwarp.data(2).scans = [];
%     
%     files = dir(['f' subjects{s} '-00' folder_num{2} '-*.nii']);
%     for f=4:length(files)
%         matlabbatch{1,1}.spm.spatial.realignunwarp.data(2).scans{f-3,1} = [data_dir files(f).name ',1'];
%     end
%     
%     cd(anat_dir)
%     anat = dir(['s' subjects{s} '-0002-00001-000192-01.nii']);
%     
%     matlabbatch{1,2}.spm.spatial.preproc.channel.vols = [];
%     
%     for a=1:length(anat)
%         matlabbatch{1,2}.spm.spatial.preproc.channel.vols{1} = [anat_dir, anat(a).name ',1' ];
%     end
%     
%     
%     
%     cd(save_dir);
%     eval(['save Preproc_DME_' subjects{s} '.mat matlabbatch']);
%     
%     
% end
% 
% 
% 
