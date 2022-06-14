%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%% BETA SERIES ANALYSIS %%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all;

% create a folder

cd('/Volumes/DATA UOR/2017_DME')

mkdir 'GLM/Beta series correlation'

% copy preprocessed files in a new directory

spm('defaults','fMRI');
spm_jobman('initcfg');

%subjects = {'KM13121601' 'KM13121604' 'KM13121703' 'KM14051502'};

subjects = {'KM13121602' 'KM13121701' 'KM13121702' 'KM13121704'...
    'KM13121801' 'KM13121802' 'KM13121803' 'KM13121804' 'KM13121901' 'KM13121902' 'KM13121903'...
    'KM13122001' 'KM13122002' 'KM13122003' 'KM13122004' 'KM14051201' 'KM14051202' 'KM14051203'...
    'KM14051204' 'KM14051301' 'KM14051302' 'KM14051304' 'KM14051401' 'KM14051402' 'KM14051403'...
    'KM14051404' 'KM14051501' 'KM14051503' 'KM14051504' 'KM14051601'...
    'KM14090101' 'KM14090102' 'KM14090103' 'KM14090104' 'KM14090201' 'KM14090202' 'KM14090301'...
    'KM14090302' 'KM14090303' 'KM14090304' 'KM14090401' 'KM14090402' 'KM14090403' 'KM14090501'...
    'KM14090502' 'KM14090503' 'KM14090504'};

for s = 1 :length(subjects)
    
    SUBJ_ID = subjects{s};
    data_dir = ['/Volumes/DATA UOR/2017_DME/Preproc_SM/' SUBJ_ID '/func/'];
    
    
    matlabbatch{1}.cfg_basicio.file_dir.dir_ops.cfg_mkdir.parent = {'/Volumes/DATA UOR/2017_DME/GLM/Beta series correlation'};
    matlabbatch{1}.cfg_basicio.file_dir.dir_ops.cfg_mkdir.name = SUBJ_ID;
    matlabbatch{2}.cfg_basicio.file_dir.file_ops.file_fplist.dir = {['/Volumes/DATA UOR/2017_DME/Preproc_SM/' SUBJ_ID '/func/']};
    matlabbatch{2}.cfg_basicio.file_dir.file_ops.file_fplist.filter = '^rp_.*';
    matlabbatch{2}.cfg_basicio.file_dir.file_ops.file_fplist.rec = 'FPList';
    matlabbatch{3}.cfg_basicio.file_dir.file_ops.file_fplist.dir = {['/Volumes/DATA UOR/2017_DME/Preproc_SM/' SUBJ_ID '/func']};
    matlabbatch{3}.cfg_basicio.file_dir.file_ops.file_fplist.filter = '^swuf.*';
    matlabbatch{3}.cfg_basicio.file_dir.file_ops.file_fplist.rec = 'FPList';
    matlabbatch{4}.cfg_basicio.file_dir.file_ops.file_move.files(1) = cfg_dep('File Selector (Batch Mode): Selected Files (^rp_.*)', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','files'));
    matlabbatch{4}.cfg_basicio.file_dir.file_ops.file_move.files(2) = cfg_dep('File Selector (Batch Mode): Selected Files (^swuf.*)', substruct('.','val', '{}',{3}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','files'));
    matlabbatch{4}.cfg_basicio.file_dir.file_ops.file_move.action.copyto(1) = cfg_dep('Make Directory: Make Directory ''KM13121601''', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','dir'));
    
    spm_jobman('run',matlabbatch);
    
end

%% checking number of trials per participant per session
cd '/Volumes/DATA UOR/2017_DME/SPM_SM/GLM/GLM1/Regress_m1'
clear;
clc;

subjects = {'KM13121601' 'KM13121602' 'KM13121604'...
    'KM13121701' 'KM13121702' 'KM13121703' 'KM13121704' 'KM13121801' 'KM13121802' 'KM13121803' 'KM13121804'...
    'KM13121901' 'KM13121902' 'KM13121903'              'KM13122001' 'KM13122002' 'KM13122003' 'KM13122004'...
    'KM14051201' 'KM14051202' 'KM14051203' 'KM14051204' 'KM14051301' 'KM14051302'              'KM14051304'...
    'KM14051401' 'KM14051402' 'KM14051403' 'KM14051404' 'KM14051501' 'KM14051502' 'KM14051503' 'KM14051504'...
    'KM14051601'                                        'KM14090101' 'KM14090102' 'KM14090103' 'KM14090104'...
    'KM14090201' 'KM14090202'                           'KM14090301' 'KM14090302' 'KM14090303' 'KM14090304'...
    'KM14090401' 'KM14090402' 'KM14090403'              'KM14090501' 'KM14090502' 'KM14090503' 'KM14090504'};

% 'KM14051401'

for s = 1:length(subjects)
    load([subjects{s} '_regress_m1_s1.mat']) % session 1
    disp([subjects{s} '_regress_m1_s1.mat'])
    
    SW_D = {onsets{1,1}}
    SW_M = {onsets{1,2}}
    SW_E = {onsets{1,3}}
    WS_D = {onsets{1,8}}
    WS_M = {onsets{1,9}}
    WS_E = {onsets{1,10}}
    
    load([subjects{s} '_regress_m1_s2.mat']) % session 2
    disp([subjects{s} '_regress_m1_s2.mat'])
    
    SW_D = {onsets{1,1}}
    SW_M = {onsets{1,2}}
    SW_E = {onsets{1,3}}
    WS_D = {onsets{1,8}}
    WS_M = {onsets{1,9}}
    WS_E = {onsets{1,10}}
    
end

%% creating .txt files containing the information about stimulus onset

%can be easily adjusted to retrieve durations of stimuli, just use find and
%replace

clear;
clc;

%%%%% all but: KM14090101
% SW: KM14090401, KM14090402, KM14090403, KM14090501, KM14090502
% WS: KM14090101, KM14090104, KM14090402, KM14090501, KM14090504

%%%%%%%%%%%%% session 1: [3 4 3] %%%%%%%%%%%%%

subjects = {'KM13121601' 'KM13121602' 'KM13121604'...
    'KM13121701' 'KM13121702' 'KM13121703' 'KM13121704' 'KM13121801' 'KM13121802' 'KM13121803' 'KM13121804'...
    'KM13121901' 'KM13121902' 'KM13121903'              'KM13122001' 'KM13122002' 'KM13122003' 'KM13122004'...
    'KM14051201' 'KM14051202' 'KM14051203' 'KM14051204' 'KM14051301' 'KM14051302'              'KM14051304'...
    'KM14051402' 'KM14051403' 'KM14051404' 'KM14051501' 'KM14051502' 'KM14051503' 'KM14051504'...
    'KM14051601'                                                     'KM14090102' 'KM14090103' 'KM14090104'...
    'KM14090201' 'KM14090202'                           'KM14090301' 'KM14090302' 'KM14090303' 'KM14090304'...
    'KM14090401'                                                                  'KM14090503'              };

for s = 1:length(subjects)
    load([subjects{s} '_regress_m1_s1.mat'])
    disp([subjects{s} '_regress_m1_s1.mat'])
    
    SW_D = {onsets{1,1}};
    SW_M = {onsets{1,2}};
    SW_E = {onsets{1,3}};
    WS_D = {onsets{1,8}};
    WS_M = {onsets{1,9}};
    WS_E = {onsets{1,10}};
    
    fileID = fopen([subjects{s} '_onsets_s1.txt'],'w');
    
    formatSpec = '%2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f \n'; %SW_D
    [nrows,ncols] = size(SW_D);
    for row = 1:nrows
        fprintf(fileID,formatSpec,SW_D{row,:});
    end
    formatSpec = '%2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f \n'; %SW_M
    [nrows,ncols] = size(SW_M);
    for row = 1:nrows
        fprintf(fileID,formatSpec,SW_M{row,:});
    end
    formatSpec = '%2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f \n'; %SW_E
    [nrows,ncols] = size(SW_E);
    for row = 1:nrows
        fprintf(fileID,formatSpec,SW_E{row,:});
    end
    
    formatSpec = '%2.3f %2.3f %2.3f\n'; %WS_D
    [nrows,ncols] = size(WS_D);
    for row = 1:nrows
        fprintf(fileID,formatSpec,WS_D{row,:});
    end
    formatSpec = '%2.3f %2.3f %2.3f %2.3f\n'; %WS_M
    [nrows,ncols] = size(WS_M);
    for row = 1:nrows
        fprintf(fileID,formatSpec,WS_M{row,:});
    end
    formatSpec = '%2.3f %2.3f %2.3f\n'; %WS_E
    [nrows,ncols] = size(WS_E);
    for row = 1:nrows
        fprintf(fileID,formatSpec,WS_E{row,:});
    end
    
    fclose(fileID);
end

%%%%%%%%%%%%% session 2: 4 3 3 %%%%%%%%%%%%%

subjects = {'KM13121601' 'KM13121602' 'KM13121604'...
    'KM13121701' 'KM13121702' 'KM13121703' 'KM13121704' 'KM13121801' 'KM13121802' 'KM13121803' 'KM13121804'...
    'KM13121901' 'KM13121902' 'KM13121903'              'KM13122001' 'KM13122002' 'KM13122003' 'KM13122004'...
    'KM14051201' 'KM14051202' 'KM14051203' 'KM14051204' 'KM14051301' 'KM14051302'              'KM14051304'...
    'KM14051401' 'KM14051402' 'KM14051403' 'KM14051404' 'KM14051501' 'KM14051502' 'KM14051503' 'KM14051504'...
    'KM14051601'                                        'KM14090101' 'KM14090102' 'KM14090103'             ...
    'KM14090201' 'KM14090202'                           'KM14090301' 'KM14090302' 'KM14090303' 'KM14090304'...
    'KM14090403'                           'KM14090502' 'KM14090503' 'KM14090504'};

for s = 1: length(subjects)
    load([subjects{s} '_regress_m1_s2.mat']) % session 2
    disp([subjects{s} '_regress_m1_s2.mat'])
    
    SW_D = {onsets{1,1}};
    SW_M = {onsets{1,2}};
    SW_E = {onsets{1,3}};
    WS_D = {onsets{1,8}};
    WS_M = {onsets{1,9}};
    WS_E = {onsets{1,10}};
    
    fileID = fopen([subjects{s} '_onsets_s2.txt'],'w');
    
    formatSpec = '%2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f \n'; %SW_D
    [nrows,ncols] = size(SW_D);
    for row = 1:nrows
        fprintf(fileID,formatSpec,SW_D{row,:});
    end
    formatSpec = '%2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f \n'; %SW_M
    [nrows,ncols] = size(SW_M);
    for row = 1:nrows
        fprintf(fileID,formatSpec,SW_M{row,:});
    end
    formatSpec = '%2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f \n'; %SW_E
    [nrows,ncols] = size(SW_E);
    for row = 1:nrows
        fprintf(fileID,formatSpec,SW_E{row,:});
    end
    
    formatSpec = '%2.3f %2.3f %2.3f %2.3f\n'; %WS_D
    [nrows,ncols] = size(WS_D);
    for row = 1:nrows
        fprintf(fileID,formatSpec,WS_D{row,:});
    end
    formatSpec = '%2.3f %2.3f %2.3f\n'; %WS_M
    [nrows,ncols] = size(WS_M);
    for row = 1:nrows
        fprintf(fileID,formatSpec,WS_M{row,:});
    end
    formatSpec = '%2.3f %2.3f %2.3f\n'; %WS_E
    [nrows,ncols] = size(WS_E);
    for row = 1:nrows
        fprintf(fileID,formatSpec,WS_E{row,:});
    end
    
    fclose(fileID);
end

%%%%%%%%%%%%% troubleshoots session 1 %%%%%%%%%%%%%
load('KM14051401_regress_m1_s1.mat')
SW_D = {onsets{1,1}};
SW_M = {onsets{1,2}};
SW_E = {onsets{1,3}};
WS_D = {onsets{1,7}};
WS_M = {onsets{1,8}};
WS_E = {onsets{1,9}};

fileID = fopen('KM14051401_onsets_s1.txt','w');
formatSpec = '%2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f \n'; %SW_D
[nrows,ncols] = size(SW_D);
for row = 1:nrows
    fprintf(fileID,formatSpec,SW_D{row,:});
end
formatSpec = '%2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f \n'; %SW_M
[nrows,ncols] = size(SW_M);
for row = 1:nrows
    fprintf(fileID,formatSpec,SW_M{row,:});
end
formatSpec = '%2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f \n'; %SW_E
[nrows,ncols] = size(SW_E);
for row = 1:nrows
    fprintf(fileID,formatSpec,SW_E{row,:});
end
formatSpec = '%2.3f %2.3f %2.3f\n'; %WS_D
[nrows,ncols] = size(WS_D);
for row = 1:nrows
    fprintf(fileID,formatSpec,WS_D{row,:});
end
formatSpec = '%2.3f %2.3f %2.3f %2.3f\n'; %WS_M
[nrows,ncols] = size(WS_M);
for row = 1:nrows
    fprintf(fileID,formatSpec,WS_M{row,:});
end
formatSpec = '%2.3f %2.3f %2.3f\n'; %WS_E
[nrows,ncols] = size(WS_E);
for row = 1:nrows
    fprintf(fileID,formatSpec,WS_E{row,:});
end
fclose(fileID);

load('KM14090101_regress_m1_s1.mat') %WS 3 3 3
SW_D = {onsets{1,1}};
SW_M = {onsets{1,2}};
SW_E = {onsets{1,3}};
WS_D = {onsets{1,8}};
WS_M = {onsets{1,9}};
WS_E = {onsets{1,10}};

fileID = fopen('KM14090101_onsets_s1.txt','w');
formatSpec = '%2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f \n'; %SW_D
[nrows,ncols] = size(SW_D);
for row = 1:nrows
    fprintf(fileID,formatSpec,SW_D{row,:});
end
formatSpec = '%2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f \n'; %SW_M
[nrows,ncols] = size(SW_M);
for row = 1:nrows
    fprintf(fileID,formatSpec,SW_M{row,:});
end
formatSpec = '%2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f \n'; %SW_E
[nrows,ncols] = size(SW_E);
for row = 1:nrows
    fprintf(fileID,formatSpec,SW_E{row,:});
end
formatSpec = '%2.3f %2.3f %2.3f\n'; %WS_D
[nrows,ncols] = size(WS_D);
for row = 1:nrows
    fprintf(fileID,formatSpec,WS_D{row,:});
end
formatSpec = '%2.3f %2.3f %2.3f\n'; %WS_M
[nrows,ncols] = size(WS_M);
for row = 1:nrows
    fprintf(fileID,formatSpec,WS_M{row,:});
end
formatSpec = '%2.3f %2.3f %2.3f\n'; %WS_E
[nrows,ncols] = size(WS_E);
for row = 1:nrows
    fprintf(fileID,formatSpec,WS_E{row,:});
end
fclose(fileID);

load('KM14090402_regress_m1_s1.mat') %SW 9 8 10 WS 2 2 2
SW_D = {onsets{1,1}};
SW_M = {onsets{1,2}};
SW_E = {onsets{1,3}};
WS_D = {onsets{1,8}};
WS_M = {onsets{1,9}};
WS_E = {onsets{1,10}};

fileID = fopen('KM14090402_onsets_s1.txt','w');
formatSpec = '%2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f \n'; %SW_D
[nrows,~] = size(SW_D);
for row = 1:nrows
    fprintf(fileID,formatSpec,SW_D{row,:});
end
formatSpec = '%2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f \n'; %SW_M
[nrows,ncols] = size(SW_M);
for row = 1:nrows
    fprintf(fileID,formatSpec,SW_M{row,:});
end
formatSpec = '%2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f \n'; %SW_E
[nrows,ncols] = size(SW_E);
for row = 1:nrows
    fprintf(fileID,formatSpec,SW_E{row,:});
end
formatSpec = '%2.3f %2.3f \n'; %WS_D
[nrows,ncols] = size(WS_D);
for row = 1:nrows
    fprintf(fileID,formatSpec,WS_D{row,:});
end
formatSpec = '%2.3f %2.3f \n'; %WS_M
[nrows,ncols] = size(WS_M);
for row = 1:nrows
    fprintf(fileID,formatSpec,WS_M{row,:});
end
formatSpec = '%2.3f %2.3f \n'; %WS_E
[nrows,ncols] = size(WS_E);
for row = 1:nrows
    fprintf(fileID,formatSpec,WS_E{row,:});
end
fclose(fileID);

load('KM14090403_regress_m1_s1.mat') %9 SW_M
SW_D = {onsets{1,1}};
SW_M = {onsets{1,2}};
SW_E = {onsets{1,3}};
WS_D = {onsets{1,8}};
WS_M = {onsets{1,9}};
WS_E = {onsets{1,10}};

fileID = fopen('KM14090403_onsets_s1.txt','w');
formatSpec = '%2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f \n'; %SW_D
[nrows,ncols] = size(SW_D);
for row = 1:nrows
    fprintf(fileID,formatSpec,SW_D{row,:});
end
formatSpec = '%2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f \n'; %SW_M
[nrows,ncols] = size(SW_M);
for row = 1:nrows
    fprintf(fileID,formatSpec,SW_M{row,:});
end
formatSpec = '%2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f \n'; %SW_E
[nrows,ncols] = size(SW_E);
for row = 1:nrows
    fprintf(fileID,formatSpec,SW_E{row,:});
end
formatSpec = '%2.3f %2.3f %2.3f\n'; %WS_D
[nrows,ncols] = size(WS_D);
for row = 1:nrows
    fprintf(fileID,formatSpec,WS_D{row,:});
end
formatSpec = '%2.3f %2.3f %2.3f %2.3f \n'; %WS_M
[nrows,ncols] = size(WS_M);
for row = 1:nrows
    fprintf(fileID,formatSpec,WS_M{row,:});
end
formatSpec = '%2.3f %2.3f %2.3f\n'; %WS_E
[nrows,ncols] = size(WS_E);
for row = 1:nrows
    fprintf(fileID,formatSpec,WS_E{row,:});
end
fclose(fileID);

load('KM14090501_regress_m1_s1.mat') %SW 10 9 8, WS 1 3 3
SW_D = {onsets{1,1}};
SW_M = {onsets{1,2}};
SW_E = {onsets{1,3}};
WS_D = {onsets{1,8}};
WS_M = {onsets{1,9}};
WS_E = {onsets{1,10}};

fileID = fopen('KM14090501_onsets_s1.txt','w');
formatSpec = '%2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f \n'; %SW_D
[nrows,ncols] = size(SW_D);
for row = 1:nrows
    fprintf(fileID,formatSpec,SW_D{row,:});
end
formatSpec = '%2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f \n'; %SW_M
[nrows,ncols] = size(SW_M);
for row = 1:nrows
    fprintf(fileID,formatSpec,SW_M{row,:});
end
formatSpec = '%2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f \n'; %SW_E
[nrows,ncols] = size(SW_E);
for row = 1:nrows
    fprintf(fileID,formatSpec,SW_E{row,:});
end
formatSpec = '%2.3f\n'; %WS_D
[nrows,ncols] = size(WS_D);
for row = 1:nrows
    fprintf(fileID,formatSpec,WS_D{row,:});
end
formatSpec = '%2.3f %2.3f %2.3f\n'; %WS_M
[nrows,ncols] = size(WS_M);
for row = 1:nrows
    fprintf(fileID,formatSpec,WS_M{row,:});
end
formatSpec = '%2.3f %2.3f %2.3f\n'; %WS_E
[nrows,ncols] = size(WS_E);
for row = 1:nrows
    fprintf(fileID,formatSpec,WS_E{row,:});
end
fclose(fileID);

load('KM14090502_regress_m1_s1.mat') %9 SW_E
SW_D = {onsets{1,1}};
SW_M = {onsets{1,2}};
SW_E = {onsets{1,3}};
WS_D = {onsets{1,8}};
WS_M = {onsets{1,9}};
WS_E = {onsets{1,10}};

fileID = fopen('KM14090502_onsets_s1.txt','w');
formatSpec = '%2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f \n'; %SW_D
[nrows,ncols] = size(SW_D);
for row = 1:nrows
    fprintf(fileID,formatSpec,SW_D{row,:});
end
formatSpec = '%2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f \n'; %SW_M
[nrows,ncols] = size(SW_M);
for row = 1:nrows
    fprintf(fileID,formatSpec,SW_M{row,:});
end
formatSpec = '%2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f \n'; %SW_E
[nrows,ncols] = size(SW_E);
for row = 1:nrows
    fprintf(fileID,formatSpec,SW_E{row,:});
end
formatSpec = '%2.3f %2.3f %2.3f\n'; %WS_D
[nrows,ncols] = size(WS_D);
for row = 1:nrows
    fprintf(fileID,formatSpec,WS_D{row,:});
end
formatSpec = '%2.3f %2.3f %2.3f %2.3f \n'; %WS_M
[nrows,ncols] = size(WS_M);
for row = 1:nrows
    fprintf(fileID,formatSpec,WS_M{row,:});
end
formatSpec = '%2.3f %2.3f %2.3f\n'; %WS_E
[nrows,ncols] = size(WS_E);
for row = 1:nrows
    fprintf(fileID,formatSpec,WS_E{row,:});
end
fclose(fileID);

load('KM14090504_regress_m1_s1.mat') %WS 3 4 2
SW_D = {onsets{1,1}};
SW_M = {onsets{1,2}};
SW_E = {onsets{1,3}};
WS_D = {onsets{1,8}};
WS_M = {onsets{1,9}};
WS_E = {onsets{1,10}};

fileID = fopen('KM14090504_onsets_s1.txt','w');
formatSpec = '%2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f \n'; %SW_D
[nrows,ncols] = size(SW_D);
for row = 1:nrows
    fprintf(fileID,formatSpec,SW_D{row,:});
end
formatSpec = '%2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f \n'; %SW_M
[nrows,ncols] = size(SW_M);
for row = 1:nrows
    fprintf(fileID,formatSpec,SW_M{row,:});
end
formatSpec = '%2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f \n'; %SW_E
[nrows,ncols] = size(SW_E);
for row = 1:nrows
    fprintf(fileID,formatSpec,SW_E{row,:});
end
formatSpec = '%2.3f %2.3f %2.3f\n'; %WS_D
[nrows,ncols] = size(WS_D);
for row = 1:nrows
    fprintf(fileID,formatSpec,WS_D{row,:});
end
formatSpec = '%2.3f %2.3f %2.3f %2.3f \n'; %WS_M
[nrows,ncols] = size(WS_M);
for row = 1:nrows
    fprintf(fileID,formatSpec,WS_M{row,:});
end
formatSpec = '%2.3f %2.3f \n'; %WS_E
[nrows,ncols] = size(WS_E);
for row = 1:nrows
    fprintf(fileID,formatSpec,WS_E{row,:});
end
fclose(fileID);

%%%%%%%%%%%%% troubleshoots session 2 %%%%%%%%%%%%%

load('KM14090104_regress_m1_s2.mat') % WS 4 3 2
SW_D = {onsets{1,1}};
SW_M = {onsets{1,2}};
SW_E = {onsets{1,3}};
WS_D = {onsets{1,8}};
WS_M = {onsets{1,9}};
WS_E = {onsets{1,10}};

fileID = fopen('KM14090104_onsets_s2.txt','w');
formatSpec = '%2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f \n'; %SW_D
[nrows,ncols] = size(SW_D);
for row = 1:nrows
    fprintf(fileID,formatSpec,SW_D{row,:});
end
formatSpec = '%2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f \n'; %SW_M
[nrows,ncols] = size(SW_M);
for row = 1:nrows
    fprintf(fileID,formatSpec,SW_M{row,:});
end
formatSpec = '%2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f \n'; %SW_E
[nrows,ncols] = size(SW_E);
for row = 1:nrows
    fprintf(fileID,formatSpec,SW_E{row,:});
end
formatSpec = '%2.3f %2.3f %2.3f %2.3f\n'; %WS_D
[nrows,ncols] = size(WS_D);
for row = 1:nrows
    fprintf(fileID,formatSpec,WS_D{row,:});
end
formatSpec = '%2.3f %2.3f %2.3f\n'; %WS_M
[nrows,ncols] = size(WS_M);
for row = 1:nrows
    fprintf(fileID,formatSpec,WS_M{row,:});
end
formatSpec = '%2.3f %2.3f \n'; %WS_E
[nrows,ncols] = size(WS_E);
for row = 1:nrows
    fprintf(fileID,formatSpec,WS_E{row,:});
end
fclose(fileID);

load('KM14090401_regress_m1_s2.mat') % 9 SW_D
SW_D = {onsets{1,1}};
SW_M = {onsets{1,2}};
SW_E = {onsets{1,3}};
WS_D = {onsets{1,8}};
WS_M = {onsets{1,9}};
WS_E = {onsets{1,10}};

fileID = fopen('KM14090401_onsets_s2.txt','w');
formatSpec = '%2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f \n'; %SW_D
[nrows,ncols] = size(SW_D);
for row = 1:nrows
    fprintf(fileID,formatSpec,SW_D{row,:});
end
formatSpec = '%2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f \n'; %SW_M
[nrows,ncols] = size(SW_M);
for row = 1:nrows
    fprintf(fileID,formatSpec,SW_M{row,:});
end
formatSpec = '%2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f \n'; %SW_E
[nrows,ncols] = size(SW_E);
for row = 1:nrows
    fprintf(fileID,formatSpec,SW_E{row,:});
end
formatSpec = '%2.3f %2.3f %2.3f %2.3f\n'; %WS_D
[nrows,ncols] = size(WS_D);
for row = 1:nrows
    fprintf(fileID,formatSpec,WS_D{row,:});
end
formatSpec = '%2.3f %2.3f %2.3f\n'; %WS_M
[nrows,ncols] = size(WS_M);
for row = 1:nrows
    fprintf(fileID,formatSpec,WS_M{row,:});
end
formatSpec = '%2.3f %2.3f %2.3f\n'; %WS_E
[nrows,ncols] = size(WS_E);
for row = 1:nrows
    fprintf(fileID,formatSpec,WS_E{row,:});
end
fclose(fileID);

load('KM14090402_regress_m1_s2.mat')
SW_D = {onsets{1,1}};
SW_M = {onsets{1,2}};
SW_E = {onsets{1,3}};
WS_D = {onsets{1,8}};
WS_M = {onsets{1,9}};
WS_E = {onsets{1,10}};

fileID = fopen('KM14090402_onsets_s2.txt','w');
formatSpec = '%2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f \n'; %SW_D
[nrows,ncols] = size(SW_D);
for row = 1:nrows
    fprintf(fileID,formatSpec,SW_D{row,:});
end
formatSpec = '%2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f \n'; %SW_M
[nrows,ncols] = size(SW_M);
for row = 1:nrows
    fprintf(fileID,formatSpec,SW_M{row,:});
end
formatSpec = '%2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f \n'; %SW_E
[nrows,ncols] = size(SW_E);
for row = 1:nrows
    fprintf(fileID,formatSpec,SW_E{row,:});
end
formatSpec = '%2.3f %2.3f %2.3f %2.3f\n'; %WS_D
[nrows,ncols] = size(WS_D);
for row = 1:nrows
    fprintf(fileID,formatSpec,WS_D{row,:});
end
formatSpec = '%2.3f %2.3f \n'; %WS_M
[nrows,ncols] = size(WS_M);
for row = 1:nrows
    fprintf(fileID,formatSpec,WS_M{row,:});
end
formatSpec = '%2.3f %2.3f \n'; %WS_E
[nrows,ncols] = size(WS_E);
for row = 1:nrows
    fprintf(fileID,formatSpec,WS_E{row,:});
end
fclose(fileID);

load('KM14090501_regress_m1_s2.mat')
SW_D = {onsets{1,1}};
SW_M = {onsets{1,2}};
SW_E = {onsets{1,3}};
WS_D = {onsets{1,8}};
WS_M = {onsets{1,9}};
WS_E = {onsets{1,10}};

fileID = fopen('KM14090501_onsets_s2.txt','w');
formatSpec = '%2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f \n'; %SW_D
[nrows,ncols] = size(SW_D);
for row = 1:nrows
    fprintf(fileID,formatSpec,SW_D{row,:});
end
formatSpec = '%2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f \n'; %SW_M
[nrows,ncols] = size(SW_M);
for row = 1:nrows
    fprintf(fileID,formatSpec,SW_M{row,:});
end
formatSpec = '%2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f \n'; %SW_E
[nrows,ncols] = size(SW_E);
for row = 1:nrows
    fprintf(fileID,formatSpec,SW_E{row,:});
end
formatSpec = '%2.3f %2.3f %2.3f %2.3f\n'; %WS_D
[nrows,ncols] = size(WS_D);
for row = 1:nrows
    fprintf(fileID,formatSpec,WS_D{row,:});
end
formatSpec = '%2.3f %2.3f \n'; %WS_M
[nrows,ncols] = size(WS_M);
for row = 1:nrows
    fprintf(fileID,formatSpec,WS_M{row,:});
end
formatSpec = '%2.3f %2.3f \n'; %WS_E
[nrows,ncols] = size(WS_E);
for row = 1:nrows
    fprintf(fileID,formatSpec,WS_E{row,:});
end
fclose(fileID);


%% copying onset.txt files to betaseries folder

clear;
clc;

spm('defaults','fMRI');
spm_jobman('initcfg');


subjects = {'KM13121601' 'KM13121602' 'KM13121604'...
    'KM13121701' 'KM13121702' 'KM13121703' 'KM13121704' 'KM13121801' 'KM13121802' 'KM13121803' 'KM13121804'...
    'KM13121901' 'KM13121902' 'KM13121903'              'KM13122001' 'KM13122002' 'KM13122003' 'KM13122004'...
    'KM14051201' 'KM14051202' 'KM14051203' 'KM14051204' 'KM14051301' 'KM14051302'              'KM14051304'...
    'KM14051401' 'KM14051402' 'KM14051403' 'KM14051404' 'KM14051501' 'KM14051502' 'KM14051503' 'KM14051504'...
    'KM14051601'                                        'KM14090101' 'KM14090102' 'KM14090103' 'KM14090104'...
    'KM14090201' 'KM14090202'                           'KM14090301' 'KM14090302' 'KM14090303' 'KM14090304'...
    'KM14090401' 'KM14090402' 'KM14090403'              'KM14090501' 'KM14090502' 'KM14090503' 'KM14090504'};

for s = 1:length(subjects)
    SUBJ_ID = subjects{s}
    
    matlabbatch{1}.cfg_basicio.file_dir.file_ops.file_fplist.dir = {'/Volumes/DATA UOR/2017_DME/SPM_SM/GLM/GLM1/Regress_m1'};
    matlabbatch{1}.cfg_basicio.file_dir.file_ops.file_fplist.filter = ['^' SUBJ_ID '_onsets_.*txt'];
    matlabbatch{1}.cfg_basicio.file_dir.file_ops.file_fplist.rec = 'FPList';
    matlabbatch{2}.cfg_basicio.file_dir.file_ops.file_move.files(1) = cfg_dep('File Selector (Batch Mode): Selected Files (^KM13121601.*txt)', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','files'));
    matlabbatch{2}.cfg_basicio.file_dir.file_ops.file_move.action.copyren.copyto = {['/Volumes/DATA UOR/2017_DME/GLM/Beta series correlation/' SUBJ_ID]};
    matlabbatch{2}.cfg_basicio.file_dir.file_ops.file_move.action.copyren.patrep(1).pattern = [SUBJ_ID '_onsets_s1'];
    matlabbatch{2}.cfg_basicio.file_dir.file_ops.file_move.action.copyren.patrep(1).repl = 'onsets1';
    matlabbatch{2}.cfg_basicio.file_dir.file_ops.file_move.action.copyren.patrep(2).pattern = [SUBJ_ID '_onsets_s2'];
    matlabbatch{2}.cfg_basicio.file_dir.file_ops.file_move.action.copyren.patrep(2).repl = 'onsets2';
    matlabbatch{2}.cfg_basicio.file_dir.file_ops.file_move.action.copyren.unique = false;
    
    
    
    spm_jobman('run',matlabbatch);
end

%% creating seperate folders for each sessions and moving the files accordingly


clear;
clc;

spm('defaults','fMRI');
spm_jobman('initcfg');

subjects = {'KM13121602' 'KM13121701' 'KM13121702' 'KM13121704'...
    'KM13121801' 'KM13121802' 'KM13121803' 'KM13121804' 'KM13121901' 'KM13121902' 'KM13121903'...
    'KM13122001' 'KM13122002' 'KM13122003' 'KM13122004' 'KM14051201' 'KM14051202' 'KM14051203'...
    'KM14051204' 'KM14051301' 'KM14051302' 'KM14051304' 'KM14051401' 'KM14051402' 'KM14051403'...
    'KM14051404' 'KM14051501' 'KM14051503' 'KM14051504' 'KM14051601'...
    'KM14090101' 'KM14090102' 'KM14090103' 'KM14090104' 'KM14090201' 'KM14090202' 'KM14090301'...
    'KM14090302' 'KM14090303' 'KM14090304' 'KM14090401' 'KM14090402' 'KM14090403' 'KM14090501'...
    'KM14090502' 'KM14090503' 'KM14090504'};

for s=1:length(subjects)
    
    SUBJ_ID = subjects{s}
    
    matlabbatch{1}.cfg_basicio.file_dir.dir_ops.cfg_mkdir.parent = {['/Volumes/DATA UOR/2017_DME/GLM/Beta series correlation/' SUBJ_ID]};
    matlabbatch{1}.cfg_basicio.file_dir.dir_ops.cfg_mkdir.name = 'session1';
    matlabbatch{2}.cfg_basicio.file_dir.dir_ops.cfg_mkdir.parent = {['/Volumes/DATA UOR/2017_DME/GLM/Beta series correlation/' SUBJ_ID]};
    matlabbatch{2}.cfg_basicio.file_dir.dir_ops.cfg_mkdir.name = 'session2';
    matlabbatch{3}.cfg_basicio.file_dir.file_ops.file_fplist.dir = {['/Volumes/DATA UOR/2017_DME/GLM/Beta series correlation/' SUBJ_ID]};
    matlabbatch{3}.cfg_basicio.file_dir.file_ops.file_fplist.filter = ['.*' SUBJ_ID '-0004-.*'];
    matlabbatch{3}.cfg_basicio.file_dir.file_ops.file_fplist.rec = 'FPList';
    matlabbatch{4}.cfg_basicio.file_dir.file_ops.file_fplist.dir = {['/Volumes/DATA UOR/2017_DME/GLM/Beta series correlation/' SUBJ_ID]};
    matlabbatch{4}.cfg_basicio.file_dir.file_ops.file_fplist.filter = '^onsets1.txt';
    matlabbatch{4}.cfg_basicio.file_dir.file_ops.file_fplist.rec = 'FPList';
    matlabbatch{5}.cfg_basicio.file_dir.file_ops.file_move.files(1) = cfg_dep('File Selector (Batch Mode): Selected Files (.*KM13121601-0008-.*)', substruct('.','val', '{}',{3}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','files'));
    matlabbatch{5}.cfg_basicio.file_dir.file_ops.file_move.files(2) = cfg_dep('File Selector (Batch Mode): Selected Files (^session1.txt)', substruct('.','val', '{}',{4}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','files'));
    matlabbatch{5}.cfg_basicio.file_dir.file_ops.file_move.action.moveto(1) = cfg_dep('Make Directory: Make Directory ''session1''', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','dir'));
    matlabbatch{6}.cfg_basicio.file_dir.file_ops.file_fplist.dir = {['/Volumes/DATA UOR/2017_DME/GLM/Beta series correlation/' SUBJ_ID]};
    matlabbatch{6}.cfg_basicio.file_dir.file_ops.file_fplist.filter = ['.*' SUBJ_ID '-0006-.*'];
    matlabbatch{6}.cfg_basicio.file_dir.file_ops.file_fplist.rec = 'FPList';
    matlabbatch{7}.cfg_basicio.file_dir.file_ops.file_fplist.dir = {['/Volumes/DATA UOR/2017_DME/GLM/Beta series correlation/' SUBJ_ID]};
    matlabbatch{7}.cfg_basicio.file_dir.file_ops.file_fplist.filter = '^onsets2.txt';
    matlabbatch{7}.cfg_basicio.file_dir.file_ops.file_fplist.rec = 'FPList';
    matlabbatch{8}.cfg_basicio.file_dir.file_ops.file_move.files(1) = cfg_dep('File Selector (Batch Mode): Selected Files (.*KM13121601-0010-.*)', substruct('.','val', '{}',{6}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','files'));
    matlabbatch{8}.cfg_basicio.file_dir.file_ops.file_move.files(2) = cfg_dep('File Selector (Batch Mode): Selected Files (^session2.txt)', substruct('.','val', '{}',{7}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','files'));
    matlabbatch{8}.cfg_basicio.file_dir.file_ops.file_move.action.moveto(1) = cfg_dep('Make Directory: Make Directory ''session2''', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','dir'));
    
    spm_jobman('run',matlabbatch);
    
end

%KM13121601

clear;
clc;

spm('defaults','fMRI');
spm_jobman('initcfg');

matlabbatch{1}.cfg_basicio.file_dir.dir_ops.cfg_mkdir.parent = {'/Volumes/DATA UOR/2017_DME/GLM/Beta series correlation/KM13121601'};
matlabbatch{1}.cfg_basicio.file_dir.dir_ops.cfg_mkdir.name = 'session1';
matlabbatch{2}.cfg_basicio.file_dir.dir_ops.cfg_mkdir.parent = {'/Volumes/DATA UOR/2017_DME/GLM/Beta series correlation/KM13121601'};
matlabbatch{2}.cfg_basicio.file_dir.dir_ops.cfg_mkdir.name = 'session2';
matlabbatch{3}.cfg_basicio.file_dir.file_ops.file_fplist.dir = {'/Volumes/DATA UOR/2017_DME/GLM/Beta series correlation/KM13121601'};
matlabbatch{3}.cfg_basicio.file_dir.file_ops.file_fplist.filter = '.*KM13121601-0008-.*';
matlabbatch{3}.cfg_basicio.file_dir.file_ops.file_fplist.rec = 'FPList';
matlabbatch{4}.cfg_basicio.file_dir.file_ops.file_fplist.dir = {'/Volumes/DATA UOR/2017_DME/GLM/Beta series correlation/KM13121601'};
matlabbatch{4}.cfg_basicio.file_dir.file_ops.file_fplist.filter = '^onsets1.txt';
matlabbatch{4}.cfg_basicio.file_dir.file_ops.file_fplist.rec = 'FPList';
matlabbatch{5}.cfg_basicio.file_dir.file_ops.file_move.files(1) = cfg_dep('File Selector (Batch Mode): Selected Files (.*KM13121601-0008-.*)', substruct('.','val', '{}',{3}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','files'));
matlabbatch{5}.cfg_basicio.file_dir.file_ops.file_move.files(2) = cfg_dep('File Selector (Batch Mode): Selected Files (^session1.txt)', substruct('.','val', '{}',{4}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','files'));
matlabbatch{5}.cfg_basicio.file_dir.file_ops.file_move.action.moveto(1) = cfg_dep('Make Directory: Make Directory ''session1''', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','dir'));
matlabbatch{6}.cfg_basicio.file_dir.file_ops.file_fplist.dir = {'/Volumes/DATA UOR/2017_DME/GLM/Beta series correlation/KM13121601'};
matlabbatch{6}.cfg_basicio.file_dir.file_ops.file_fplist.filter = '.*KM13121601-0010-.*';
matlabbatch{6}.cfg_basicio.file_dir.file_ops.file_fplist.rec = 'FPList';
matlabbatch{7}.cfg_basicio.file_dir.file_ops.file_fplist.dir = {'/Volumes/DATA UOR/2017_DME/GLM/Beta series correlation/KM13121601'};
matlabbatch{7}.cfg_basicio.file_dir.file_ops.file_fplist.filter = '^onsets2.txt';
matlabbatch{7}.cfg_basicio.file_dir.file_ops.file_fplist.rec = 'FPList';
matlabbatch{8}.cfg_basicio.file_dir.file_ops.file_move.files(1) = cfg_dep('File Selector (Batch Mode): Selected Files (.*KM13121601-0010-.*)', substruct('.','val', '{}',{6}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','files'));
matlabbatch{8}.cfg_basicio.file_dir.file_ops.file_move.files(2) = cfg_dep('File Selector (Batch Mode): Selected Files (^session2.txt)', substruct('.','val', '{}',{7}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','files'));
matlabbatch{8}.cfg_basicio.file_dir.file_ops.file_move.action.moveto(1) = cfg_dep('Make Directory: Make Directory ''session2''', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','dir'));

spm_jobman('run',matlabbatch);

%KM13121604

clear;
clc;

spm('defaults','fMRI');
spm_jobman('initcfg');

matlabbatch{1}.cfg_basicio.file_dir.dir_ops.cfg_mkdir.parent = {'/Volumes/DATA UOR/2017_DME/GLM/Beta series correlation/KM13121604'};
matlabbatch{1}.cfg_basicio.file_dir.dir_ops.cfg_mkdir.name = 'session1';
matlabbatch{2}.cfg_basicio.file_dir.dir_ops.cfg_mkdir.parent = {'/Volumes/DATA UOR/2017_DME/GLM/Beta series correlation/KM13121604'};
matlabbatch{2}.cfg_basicio.file_dir.dir_ops.cfg_mkdir.name = 'session2';
matlabbatch{3}.cfg_basicio.file_dir.file_ops.file_fplist.dir = {'/Volumes/DATA UOR/2017_DME/GLM/Beta series correlation/KM13121604'};
matlabbatch{3}.cfg_basicio.file_dir.file_ops.file_fplist.filter = '.*KM13121604-0004-.*';
matlabbatch{3}.cfg_basicio.file_dir.file_ops.file_fplist.rec = 'FPList';
matlabbatch{4}.cfg_basicio.file_dir.file_ops.file_fplist.dir = {'/Volumes/DATA UOR/2017_DME/GLM/Beta series correlation/KM13121604'};
matlabbatch{4}.cfg_basicio.file_dir.file_ops.file_fplist.filter = '^onsets1.txt';
matlabbatch{4}.cfg_basicio.file_dir.file_ops.file_fplist.rec = 'FPList';
matlabbatch{5}.cfg_basicio.file_dir.file_ops.file_move.files(1) = cfg_dep('File Selector (Batch Mode): Selected Files (.*KM13121601-0008-.*)', substruct('.','val', '{}',{3}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','files'));
matlabbatch{5}.cfg_basicio.file_dir.file_ops.file_move.files(2) = cfg_dep('File Selector (Batch Mode): Selected Files (^session1.txt)', substruct('.','val', '{}',{4}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','files'));
matlabbatch{5}.cfg_basicio.file_dir.file_ops.file_move.action.moveto(1) = cfg_dep('Make Directory: Make Directory ''session1''', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','dir'));
matlabbatch{6}.cfg_basicio.file_dir.file_ops.file_fplist.dir = {'/Volumes/DATA UOR/2017_DME/GLM/Beta series correlation/KM13121604'};
matlabbatch{6}.cfg_basicio.file_dir.file_ops.file_fplist.filter = '.*KM13121604-0007-.*';
matlabbatch{6}.cfg_basicio.file_dir.file_ops.file_fplist.rec = 'FPList';
matlabbatch{7}.cfg_basicio.file_dir.file_ops.file_fplist.dir = {'/Volumes/DATA UOR/2017_DME/GLM/Beta series correlation/KM13121604'};
matlabbatch{7}.cfg_basicio.file_dir.file_ops.file_fplist.filter = '^onsets2.txt';
matlabbatch{7}.cfg_basicio.file_dir.file_ops.file_fplist.rec = 'FPList';
matlabbatch{8}.cfg_basicio.file_dir.file_ops.file_move.files(1) = cfg_dep('File Selector (Batch Mode): Selected Files (.*KM13121601-0010-.*)', substruct('.','val', '{}',{6}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','files'));
matlabbatch{8}.cfg_basicio.file_dir.file_ops.file_move.files(2) = cfg_dep('File Selector (Batch Mode): Selected Files (^session2.txt)', substruct('.','val', '{}',{7}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','files'));
matlabbatch{8}.cfg_basicio.file_dir.file_ops.file_move.action.moveto(1) = cfg_dep('Make Directory: Make Directory ''session2''', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','dir'));

spm_jobman('run',matlabbatch);

%KM13121703

clear;
clc;

spm('defaults','fMRI');
spm_jobman('initcfg');

matlabbatch{1}.cfg_basicio.file_dir.dir_ops.cfg_mkdir.parent = {'/Volumes/DATA UOR/2017_DME/GLM/Beta series correlation/KM13121703'};
matlabbatch{1}.cfg_basicio.file_dir.dir_ops.cfg_mkdir.name = 'session1';
matlabbatch{2}.cfg_basicio.file_dir.dir_ops.cfg_mkdir.parent = {'/Volumes/DATA UOR/2017_DME/GLM/Beta series correlation/KM13121703'};
matlabbatch{2}.cfg_basicio.file_dir.dir_ops.cfg_mkdir.name = 'session2';
matlabbatch{3}.cfg_basicio.file_dir.file_ops.file_fplist.dir = {'/Volumes/DATA UOR/2017_DME/GLM/Beta series correlation/KM13121703'};
matlabbatch{3}.cfg_basicio.file_dir.file_ops.file_fplist.filter = '.*KM13121703-0006-.*';
matlabbatch{3}.cfg_basicio.file_dir.file_ops.file_fplist.rec = 'FPList';
matlabbatch{4}.cfg_basicio.file_dir.file_ops.file_fplist.dir = {'/Volumes/DATA UOR/2017_DME/GLM/Beta series correlation/KM13121703'};
matlabbatch{4}.cfg_basicio.file_dir.file_ops.file_fplist.filter = '^onsets1.txt';
matlabbatch{4}.cfg_basicio.file_dir.file_ops.file_fplist.rec = 'FPList';
matlabbatch{5}.cfg_basicio.file_dir.file_ops.file_move.files(1) = cfg_dep('File Selector (Batch Mode): Selected Files (.*KM13121601-0008-.*)', substruct('.','val', '{}',{3}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','files'));
matlabbatch{5}.cfg_basicio.file_dir.file_ops.file_move.files(2) = cfg_dep('File Selector (Batch Mode): Selected Files (^session1.txt)', substruct('.','val', '{}',{4}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','files'));
matlabbatch{5}.cfg_basicio.file_dir.file_ops.file_move.action.moveto(1) = cfg_dep('Make Directory: Make Directory ''session1''', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','dir'));
matlabbatch{6}.cfg_basicio.file_dir.file_ops.file_fplist.dir = {'/Volumes/DATA UOR/2017_DME/GLM/Beta series correlation/KM13121703'};
matlabbatch{6}.cfg_basicio.file_dir.file_ops.file_fplist.filter = '.*KM13121703-0008-.*';
matlabbatch{6}.cfg_basicio.file_dir.file_ops.file_fplist.rec = 'FPList';
matlabbatch{7}.cfg_basicio.file_dir.file_ops.file_fplist.dir = {'/Volumes/DATA UOR/2017_DME/GLM/Beta series correlation/KM13121703'};
matlabbatch{7}.cfg_basicio.file_dir.file_ops.file_fplist.filter = '^onsets2.txt';
matlabbatch{7}.cfg_basicio.file_dir.file_ops.file_fplist.rec = 'FPList';
matlabbatch{8}.cfg_basicio.file_dir.file_ops.file_move.files(1) = cfg_dep('File Selector (Batch Mode): Selected Files (.*KM13121601-0010-.*)', substruct('.','val', '{}',{6}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','files'));
matlabbatch{8}.cfg_basicio.file_dir.file_ops.file_move.files(2) = cfg_dep('File Selector (Batch Mode): Selected Files (^session2.txt)', substruct('.','val', '{}',{7}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','files'));
matlabbatch{8}.cfg_basicio.file_dir.file_ops.file_move.action.moveto(1) = cfg_dep('Make Directory: Make Directory ''session2''', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','dir'));

spm_jobman('run',matlabbatch);

%KM14051502

clear;
clc;

spm('defaults','fMRI');
spm_jobman('initcfg');

matlabbatch{1}.cfg_basicio.file_dir.dir_ops.cfg_mkdir.parent = {'/Volumes/DATA UOR/2017_DME/GLM/Beta series correlation/KM14051502'};
matlabbatch{1}.cfg_basicio.file_dir.dir_ops.cfg_mkdir.name = 'session1';
matlabbatch{2}.cfg_basicio.file_dir.dir_ops.cfg_mkdir.parent = {'/Volumes/DATA UOR/2017_DME/GLM/Beta series correlation/KM14051502'};
matlabbatch{2}.cfg_basicio.file_dir.dir_ops.cfg_mkdir.name = 'session2';
matlabbatch{3}.cfg_basicio.file_dir.file_ops.file_fplist.dir = {'/Volumes/DATA UOR/2017_DME/GLM/Beta series correlation/KM14051502'};
matlabbatch{3}.cfg_basicio.file_dir.file_ops.file_fplist.filter = '.*KM14051502-0004-.*';
matlabbatch{3}.cfg_basicio.file_dir.file_ops.file_fplist.rec = 'FPList';
matlabbatch{4}.cfg_basicio.file_dir.file_ops.file_fplist.dir = {'/Volumes/DATA UOR/2017_DME/GLM/Beta series correlation/KM14051502'};
matlabbatch{4}.cfg_basicio.file_dir.file_ops.file_fplist.filter = '^onsets1.txt';
matlabbatch{4}.cfg_basicio.file_dir.file_ops.file_fplist.rec = 'FPList';
matlabbatch{5}.cfg_basicio.file_dir.file_ops.file_move.files(1) = cfg_dep('File Selector (Batch Mode): Selected Files (.*KM13121601-0008-.*)', substruct('.','val', '{}',{3}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','files'));
matlabbatch{5}.cfg_basicio.file_dir.file_ops.file_move.files(2) = cfg_dep('File Selector (Batch Mode): Selected Files (^session1.txt)', substruct('.','val', '{}',{4}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','files'));
matlabbatch{5}.cfg_basicio.file_dir.file_ops.file_move.action.moveto(1) = cfg_dep('Make Directory: Make Directory ''session1''', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','dir'));
matlabbatch{6}.cfg_basicio.file_dir.file_ops.file_fplist.dir = {'/Volumes/DATA UOR/2017_DME/GLM/Beta series correlation/KM14051502'};
matlabbatch{6}.cfg_basicio.file_dir.file_ops.file_fplist.filter = '.*KM14051502-0010-.*';
matlabbatch{6}.cfg_basicio.file_dir.file_ops.file_fplist.rec = 'FPList';
matlabbatch{7}.cfg_basicio.file_dir.file_ops.file_fplist.dir = {'/Volumes/DATA UOR/2017_DME/GLM/Beta series correlation/KM14051502'};
matlabbatch{7}.cfg_basicio.file_dir.file_ops.file_fplist.filter = '^onsets2.txt';
matlabbatch{7}.cfg_basicio.file_dir.file_ops.file_fplist.rec = 'FPList';
matlabbatch{8}.cfg_basicio.file_dir.file_ops.file_move.files(1) = cfg_dep('File Selector (Batch Mode): Selected Files (.*KM13121601-0010-.*)', substruct('.','val', '{}',{6}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','files'));
matlabbatch{8}.cfg_basicio.file_dir.file_ops.file_move.files(2) = cfg_dep('File Selector (Batch Mode): Selected Files (^session2.txt)', substruct('.','val', '{}',{7}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','files'));
matlabbatch{8}.cfg_basicio.file_dir.file_ops.file_move.action.moveto(1) = cfg_dep('Make Directory: Make Directory ''session2''', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','dir'));

spm_jobman('run',matlabbatch);

%% run anadef :    DME_anadef_firstLevel_spec.m


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
AnaDef.Prefix               = 'swu';
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

%added by JKL, modified by SM
job_path='/Volumes/DATA UOR/2017_DME';

% name of output-file (analysis objects)   %modified by JKL and SM (to replace
% basco_path with job_path)
AnaDef.Outfile              = fullfile(job_path,'GLM','Beta series correlation', 'out_estimated.mat');

cSubj = 0; % subject counter

%vp = {'KM13121601'};
vp = {'KM13121601' 'KM13121602' 'KM13121604'...
    'KM13121701' 'KM13121702' 'KM13121703' 'KM13121704' 'KM13121801' 'KM13121802' 'KM13121803' 'KM13121804'...
    'KM13121901' 'KM13121902' 'KM13121903'              'KM13122001' 'KM13122002' 'KM13122003' 'KM13122004'...
    'KM14051201' 'KM14051202' 'KM14051203' 'KM14051204' 'KM14051301' 'KM14051302'              'KM14051304'...
    'KM14051401' 'KM14051402' 'KM14051403' 'KM14051404' 'KM14051501' 'KM14051502' 'KM14051503' 'KM14051504'...
    'KM14051601'                                        'KM14090101' 'KM14090102' 'KM14090103' 'KM14090104'...
    'KM14090201' 'KM14090202'                           'KM14090301' 'KM14090302' 'KM14090303' 'KM14090304'...
    'KM14090401' 'KM14090402' 'KM14090403'              'KM14090501' 'KM14090502' 'KM14090503' 'KM14090504'}; % needs adjustment


%modified by JKL and SM (to replace basco_path with job_path)
data_dir = fullfile(job_path,'GLM','Beta series correlation'); % directory containing all subject folders


% all subjects
for i=1:length(vp)
    cSubj = cSubj+1;
    AnaDef.Subj{cSubj}.DataPath = fullfile(data_dir,vp{i});
    AnaDef.Subj{cSubj}.NumRuns  = 2;
    AnaDef.Subj{cSubj}.RunDirs  = {'session1','session2'}; % modified by SM
    AnaDef.Subj{cSubj}.Onsets   = {'onsets1.txt','onsets2.txt'}; % modified by SM
    AnaDef.Subj{cSubj}.Duration = [1.5 1.5 1.5 1.5 1.5 1.5]; % modified by SM
end
mars
%
AnaDef.NumSubjects = cSubj;

%% extracting correlation maps

% seeds: bilateral_peaks_5mm_sphere_roi.mat, left_peak_-9,5,-8_5mm_sphere_roi.mat, right_peak_9,5,-8_5mm_sphere_roi.mat
%
% mask: brainmask_roi.mat
%
% compute correlation maps for conditions: 1, 2, 3, 4, 5, 6, 1 2 3, 4 5 6

%% handling of zfcmap

clear;
clear all;
clc;

spm('defaults','fMRI');
spm_jobman('initcfg');

groups = {'Control' 'Reward' 'Gambling'};

for i = 1:length(groups)
    
    if i == 1 % control
        subjects = {'KM13121601' 'KM13121701' 'KM13121704' 'KM13121801' 'KM13121803' 'KM13121901'...
            'KM13122001' 'KM13122002' 'KM13122004' 'KM14051202' 'KM14051204'...
            'KM14051304' 'KM14051403' 'KM14051404' 'KM14051503' 'KM14051504' 'KM14051601'};
    elseif i == 2 % reward
        subjects = {'KM13121602' 'KM13121604' 'KM13121702' 'KM13121703' 'KM13121802' 'KM13121804'...
            'KM13121902' 'KM13121903' 'KM13122003' 'KM14051201' 'KM14051203'...
            'KM14051301' 'KM14051302' 'KM14051401' 'KM14051402' 'KM14051501' 'KM14051502'};
    elseif i == 3 % gambling
        subjects = {'KM14090101' 'KM14090102' 'KM14090103' 'KM14090104' 'KM14090201' 'KM14090202'...
            'KM14090301' 'KM14090302' 'KM14090303' 'KM14090304' 'KM14090401' 'KM14090402' 'KM14090403'...
            'KM14090501' 'KM14090502' 'KM14090503' 'KM14090504'};
    end
    
    
    for s = 1:length(subjects)
        SUBJ_ID = subjects{s}
        
        matlabbatch{1}.cfg_basicio.file_dir.file_ops.file_fplist.dir = {['/Volumes/DATA UOR/2017_DME/GLM/Beta series correlation/' SUBJ_ID '/betaseries']};
        matlabbatch{1}.cfg_basicio.file_dir.file_ops.file_fplist.filter = '^zfcmap.*';
        matlabbatch{1}.cfg_basicio.file_dir.file_ops.file_fplist.rec = 'FPList';
        matlabbatch{2}.cfg_basicio.file_dir.file_ops.file_move.files(1) = cfg_dep('File Selector (Batch Mode): Selected Files (^zfcmap.*)', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','files'));
        matlabbatch{2}.cfg_basicio.file_dir.file_ops.file_move.action.copyren.copyto = {['/Volumes/DATA UOR/2017_DME/GLM/Beta series correlation/3x3 ANOVA/' groups{i} ]};
        matlabbatch{2}.cfg_basicio.file_dir.file_ops.file_move.action.copyren.patrep.pattern = 'zfcmap';
        matlabbatch{2}.cfg_basicio.file_dir.file_ops.file_move.action.copyren.patrep.repl = SUBJ_ID;
        matlabbatch{2}.cfg_basicio.file_dir.file_ops.file_move.action.copyren.unique = false;
        
        
        
        spm_jobman('run',matlabbatch);
    end
end


%% image calculation SW - WS --> SWWS_only_DME

clear;
clc;

spm('defaults','fMRI');
spm_jobman('initcfg');

groups = {'Control' 'Reward' 'Gambling'};

lateral_str = {'_left_peak' '_right_peak' '_bilateral_peak'};

for i = 1:length(groups)
    
    matlabbatch{1}.cfg_basicio.file_dir.dir_ops.cfg_mkdir.parent = {['/Volumes/DATA UOR/2017_DME/GLM/Beta series correlation/3x3 ANOVA/' groups{i} '/'] };
    matlabbatch{1}.cfg_basicio.file_dir.dir_ops.cfg_mkdir.name = 'output imCalc';
    
    if i == 1 % control
        subjects = {'KM13121601' 'KM13121701' 'KM13121704' 'KM13121801' 'KM13121803' 'KM13121901'...
            'KM13122001' 'KM13122002' 'KM13122004' 'KM14051202' 'KM14051204'...
            'KM14051304' 'KM14051403' 'KM14051404' 'KM14051503' 'KM14051504' 'KM14051601'};
    elseif i == 2 % reward
        subjects = {'KM13121602' 'KM13121604' 'KM13121702' 'KM13121703' 'KM13121802' 'KM13121804'...
            'KM13121902' 'KM13121903' 'KM13122003' 'KM14051201' 'KM14051203'...
            'KM14051301' 'KM14051302' 'KM14051401' 'KM14051402' 'KM14051501' 'KM14051502'};
    elseif i == 3 % gambling
        subjects = {'KM14090101' 'KM14090102' 'KM14090103' 'KM14090104' 'KM14090201' 'KM14090202'...
            'KM14090301' 'KM14090302' 'KM14090303' 'KM14090304' 'KM14090401' 'KM14090402' 'KM14090403'...
            'KM14090501' 'KM14090502' 'KM14090503' 'KM14090504'};
    end
    
    for s = 1:length(subjects)
        SUBJ_ID = subjects{s}
        
        for l = 1:length(lateral_str)
            
            matlabbatch{2}.spm.util.imcalc.input = {
                ['/Volumes/DATA UOR/2017_DME/GLM/Beta series correlation/3x3 ANOVA/' groups{i} '/' SUBJ_ID lateral_str{l} '_1.nii,1']
                ['/Volumes/DATA UOR/2017_DME/GLM/Beta series correlation/3x3 ANOVA/' groups{i} '/' SUBJ_ID lateral_str{l} '_4.nii,1']
                };
            matlabbatch{2}.spm.util.imcalc.output = [ SUBJ_ID lateral_str{l} '_SWWS_only_D'];
            matlabbatch{2}.spm.util.imcalc.outdir(1) = cfg_dep('Make Directory: Make Directory ''output imCalc''', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','dir'));
            matlabbatch{2}.spm.util.imcalc.expression = 'i1 - i2';
            matlabbatch{2}.spm.util.imcalc.var = struct('name', {}, 'value', {});
            matlabbatch{2}.spm.util.imcalc.options.dmtx = 0;
            matlabbatch{2}.spm.util.imcalc.options.mask = 0;
            matlabbatch{2}.spm.util.imcalc.options.interp = 1;
            matlabbatch{2}.spm.util.imcalc.options.dtype = 4;
            matlabbatch{3}.spm.util.imcalc.input = {
                ['/Volumes/DATA UOR/2017_DME/GLM/Beta series correlation/3x3 ANOVA/' groups{i} '/' SUBJ_ID lateral_str{l} '_2.nii,1']
                ['/Volumes/DATA UOR/2017_DME/GLM/Beta series correlation/3x3 ANOVA/' groups{i} '/' SUBJ_ID lateral_str{l} '_5.nii,1']
                };
            matlabbatch{3}.spm.util.imcalc.output = [ SUBJ_ID lateral_str{l} '_SWWS_only_M'];
            matlabbatch{3}.spm.util.imcalc.outdir(1) = cfg_dep('Make Directory: Make Directory ''output imCalc''', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','dir'));
            matlabbatch{3}.spm.util.imcalc.expression = 'i1 - i2';
            matlabbatch{3}.spm.util.imcalc.var = struct('name', {}, 'value', {});
            matlabbatch{3}.spm.util.imcalc.options.dmtx = 0;
            matlabbatch{3}.spm.util.imcalc.options.mask = 0;
            matlabbatch{3}.spm.util.imcalc.options.interp = 1;
            matlabbatch{3}.spm.util.imcalc.options.dtype = 4;
            matlabbatch{4}.spm.util.imcalc.input = {
                ['/Volumes/DATA UOR/2017_DME/GLM/Beta series correlation/3x3 ANOVA/' groups{i} '/' SUBJ_ID lateral_str{l} '_3.nii,1']
                ['/Volumes/DATA UOR/2017_DME/GLM/Beta series correlation/3x3 ANOVA/' groups{i} '/' SUBJ_ID lateral_str{l} '_6.nii,1']
                };
            matlabbatch{4}.spm.util.imcalc.output = [ SUBJ_ID lateral_str{l} '_SWWS_only_E'];
            matlabbatch{4}.spm.util.imcalc.outdir(1) = cfg_dep('Make Directory: Make Directory ''output imCalc''', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','dir'));
            matlabbatch{4}.spm.util.imcalc.expression = 'i1 - i2';
            matlabbatch{4}.spm.util.imcalc.var = struct('name', {}, 'value', {});
            matlabbatch{4}.spm.util.imcalc.options.dmtx = 0;
            matlabbatch{4}.spm.util.imcalc.options.mask = 0;
            matlabbatch{4}.spm.util.imcalc.options.interp = 1;
            matlabbatch{4}.spm.util.imcalc.options.dtype = 4;
            
            spm_jobman('run',matlabbatch);
            
        end
    end
    
end

%% image calculation SW - WS --> SWWS_DME

clear;
clc;

spm('defaults','fMRI');
spm_jobman('initcfg');

groups = {'Control' 'Reward' 'Gambling'};

lateral_str = {'_left_peak' '_right_peak' '_bilateral_peak'};

for i = 1:length(groups)
    
    matlabbatch{1}.cfg_basicio.file_dir.dir_ops.cfg_mkdir.parent = {['/Volumes/DATA UOR/2017_DME/GLM/Beta series correlation/3x3 ANOVA/' groups{i} '/'] };
    matlabbatch{1}.cfg_basicio.file_dir.dir_ops.cfg_mkdir.name = 'output imCalc';
    
    if i == 1 % control
        subjects = {'KM13121601' 'KM13121701' 'KM13121704' 'KM13121801' 'KM13121803' 'KM13121901'...
            'KM13122001' 'KM13122002' 'KM13122004' 'KM14051202' 'KM14051204'...
            'KM14051304' 'KM14051403' 'KM14051404' 'KM14051503' 'KM14051504' 'KM14051601'};
    elseif i == 2 % reward
        subjects = {'KM13121602' 'KM13121604' 'KM13121702' 'KM13121703' 'KM13121802' 'KM13121804'...
            'KM13121902' 'KM13121903' 'KM13122003' 'KM14051201' 'KM14051203'...
            'KM14051301' 'KM14051302' 'KM14051401' 'KM14051402' 'KM14051501' 'KM14051502'};
    elseif i == 3 % gambling
        subjects = {'KM14090101' 'KM14090102' 'KM14090103' 'KM14090104' 'KM14090201' 'KM14090202'...
            'KM14090301' 'KM14090302' 'KM14090303' 'KM14090304' 'KM14090401' 'KM14090402' 'KM14090403'...
            'KM14090501' 'KM14090502' 'KM14090503' 'KM14090504'};
    end
    
    for s = 1:length(subjects)
        SUBJ_ID = subjects{s}
        
        for l = 1:length(lateral_str)
            
            matlabbatch{2}.spm.util.imcalc.input = {
                ['/Volumes/DATA UOR/2017_DME/GLM/Beta series correlation/3x3 ANOVA/' groups{i} '/' SUBJ_ID lateral_str{l} '_1.nii,1']
                ['/Volumes/DATA UOR/2017_DME/GLM/Beta series correlation/3x3 ANOVA/' groups{i} '/' SUBJ_ID lateral_str{l} '_4__5__6.nii,1']
                };
            matlabbatch{2}.spm.util.imcalc.output = [ SUBJ_ID lateral_str{l} '_SWWS_D'];
            matlabbatch{2}.spm.util.imcalc.outdir(1) = cfg_dep('Make Directory: Make Directory ''output imCalc''', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','dir'));
            matlabbatch{2}.spm.util.imcalc.expression = 'i1 - i2';
            matlabbatch{2}.spm.util.imcalc.var = struct('name', {}, 'value', {});
            matlabbatch{2}.spm.util.imcalc.options.dmtx = 0;
            matlabbatch{2}.spm.util.imcalc.options.mask = 0;
            matlabbatch{2}.spm.util.imcalc.options.interp = 1;
            matlabbatch{2}.spm.util.imcalc.options.dtype = 4;
            matlabbatch{3}.spm.util.imcalc.input = {
                ['/Volumes/DATA UOR/2017_DME/GLM/Beta series correlation/3x3 ANOVA/' groups{i} '/' SUBJ_ID lateral_str{l} '_2.nii,1']
                ['/Volumes/DATA UOR/2017_DME/GLM/Beta series correlation/3x3 ANOVA/' groups{i} '/' SUBJ_ID lateral_str{l} '_4__5__6.nii,1']
                };
            matlabbatch{3}.spm.util.imcalc.output = [ SUBJ_ID lateral_str{l} '_SWWS_M'];
            matlabbatch{3}.spm.util.imcalc.outdir(1) = cfg_dep('Make Directory: Make Directory ''output imCalc''', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','dir'));
            matlabbatch{3}.spm.util.imcalc.expression = 'i1 - i2';
            matlabbatch{3}.spm.util.imcalc.var = struct('name', {}, 'value', {});
            matlabbatch{3}.spm.util.imcalc.options.dmtx = 0;
            matlabbatch{3}.spm.util.imcalc.options.mask = 0;
            matlabbatch{3}.spm.util.imcalc.options.interp = 1;
            matlabbatch{3}.spm.util.imcalc.options.dtype = 4;
            matlabbatch{4}.spm.util.imcalc.input = {
                ['/Volumes/DATA UOR/2017_DME/GLM/Beta series correlation/3x3 ANOVA/' groups{i} '/' SUBJ_ID lateral_str{l} '_3.nii,1']
                ['/Volumes/DATA UOR/2017_DME/GLM/Beta series correlation/3x3 ANOVA/' groups{i} '/' SUBJ_ID lateral_str{l} '_4__5__6.nii,1']
                };
            matlabbatch{4}.spm.util.imcalc.output = [ SUBJ_ID lateral_str{l} '_SWWS_E'];
            matlabbatch{4}.spm.util.imcalc.outdir(1) = cfg_dep('Make Directory: Make Directory ''output imCalc''', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','dir'));
            matlabbatch{4}.spm.util.imcalc.expression = 'i1 - i2';
            matlabbatch{4}.spm.util.imcalc.var = struct('name', {}, 'value', {});
            matlabbatch{4}.spm.util.imcalc.options.dmtx = 0;
            matlabbatch{4}.spm.util.imcalc.options.mask = 0;
            matlabbatch{4}.spm.util.imcalc.options.interp = 1;
            matlabbatch{4}.spm.util.imcalc.options.dtype = 4;
            
            spm_jobman('run',matlabbatch);
            
        end
    end
    
end

%% image calculation SW - WS --> SW-WS

clear;
clc;

spm('defaults','fMRI');
spm_jobman('initcfg');

groups = {'Control' 'Reward' 'Gambling'};

lateral_str = {'_left_peak' '_right_peak' '_bilateral_peak'};

for i = 1:length(groups)
    
    matlabbatch{1}.cfg_basicio.file_dir.dir_ops.cfg_mkdir.parent = {['/Volumes/DATA UOR/2017_DME/GLM/Beta series correlation/3x3 ANOVA/' groups{i} '/'] };
    matlabbatch{1}.cfg_basicio.file_dir.dir_ops.cfg_mkdir.name = 'output imCalc';
    
    if i == 1 % control
        subjects = {'KM13121601' 'KM13121701' 'KM13121704' 'KM13121801' 'KM13121803' 'KM13121901'...
            'KM13122001' 'KM13122002' 'KM13122004' 'KM14051202' 'KM14051204'...
            'KM14051304' 'KM14051403' 'KM14051404' 'KM14051503' 'KM14051504' 'KM14051601'};
    elseif i == 2 % reward
        subjects = {'KM13121602' 'KM13121604' 'KM13121702' 'KM13121703' 'KM13121802' 'KM13121804'...
            'KM13121902' 'KM13121903' 'KM13122003' 'KM14051201' 'KM14051203'...
            'KM14051301' 'KM14051302' 'KM14051401' 'KM14051402' 'KM14051501' 'KM14051502'};
    elseif i == 3 % gambling
        subjects = {'KM14090101' 'KM14090102' 'KM14090103' 'KM14090104' 'KM14090201' 'KM14090202'...
            'KM14090301' 'KM14090302' 'KM14090303' 'KM14090304' 'KM14090401' 'KM14090402' 'KM14090403'...
            'KM14090501' 'KM14090502' 'KM14090503' 'KM14090504'};
    end
    
    for s = 1:length(subjects)
        SUBJ_ID = subjects{s}
        
        for l = 1:length(lateral_str)
            
            matlabbatch{2}.spm.util.imcalc.input = {
                ['/Volumes/DATA UOR/2017_DME/GLM/Beta series correlation/3x3 ANOVA/' groups{i} '/' SUBJ_ID lateral_str{l} '_1__2__3.nii,1']
                ['/Volumes/DATA UOR/2017_DME/GLM/Beta series correlation/3x3 ANOVA/' groups{i} '/' SUBJ_ID lateral_str{l} '_4__5__6.nii,1']
                };
            matlabbatch{2}.spm.util.imcalc.output = [ SUBJ_ID lateral_str{l} '_SW-WS'];
            matlabbatch{2}.spm.util.imcalc.outdir(1) = cfg_dep('Make Directory: Make Directory ''output imCalc''', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','dir'));
            matlabbatch{2}.spm.util.imcalc.expression = 'i1 - i2';
            matlabbatch{2}.spm.util.imcalc.var = struct('name', {}, 'value', {});
            matlabbatch{2}.spm.util.imcalc.options.dmtx = 0;
            matlabbatch{2}.spm.util.imcalc.options.mask = 0;
            matlabbatch{2}.spm.util.imcalc.options.interp = 1;
            matlabbatch{2}.spm.util.imcalc.options.dtype = 4;
            matlabbatch{3}.spm.util.imcalc.input = {
                ['/Volumes/DATA UOR/2017_DME/GLM/Beta series correlation/3x3 ANOVA/' groups{i} '/' SUBJ_ID lateral_str{l} '_1__2__3.nii,1']
                ['/Volumes/DATA UOR/2017_DME/GLM/Beta series correlation/3x3 ANOVA/' groups{i} '/' SUBJ_ID lateral_str{l} '_4__5__6.nii,1']
                };
            matlabbatch{3}.spm.util.imcalc.output = [ SUBJ_ID lateral_str{l} '_SW-WS'];
            matlabbatch{3}.spm.util.imcalc.outdir(1) = cfg_dep('Make Directory: Make Directory ''output imCalc''', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','dir'));
            matlabbatch{3}.spm.util.imcalc.expression = 'i1 - i2';
            matlabbatch{3}.spm.util.imcalc.var = struct('name', {}, 'value', {});
            matlabbatch{3}.spm.util.imcalc.options.dmtx = 0;
            matlabbatch{3}.spm.util.imcalc.options.mask = 0;
            matlabbatch{3}.spm.util.imcalc.options.interp = 1;
            matlabbatch{3}.spm.util.imcalc.options.dtype = 4;
            matlabbatch{4}.spm.util.imcalc.input = {
                ['/Volumes/DATA UOR/2017_DME/GLM/Beta series correlation/3x3 ANOVA/' groups{i} '/' SUBJ_ID lateral_str{l} '_1__2__3.nii,1']
                ['/Volumes/DATA UOR/2017_DME/GLM/Beta series correlation/3x3 ANOVA/' groups{i} '/' SUBJ_ID lateral_str{l} '_4__5__6.nii,1']
                };
            matlabbatch{4}.spm.util.imcalc.output = [ SUBJ_ID lateral_str{l} '_SW-WS'];
            matlabbatch{4}.spm.util.imcalc.outdir(1) = cfg_dep('Make Directory: Make Directory ''output imCalc''', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','dir'));
            matlabbatch{4}.spm.util.imcalc.expression = 'i1 - i2';
            matlabbatch{4}.spm.util.imcalc.var = struct('name', {}, 'value', {});
            matlabbatch{4}.spm.util.imcalc.options.dmtx = 0;
            matlabbatch{4}.spm.util.imcalc.options.mask = 0;
            matlabbatch{4}.spm.util.imcalc.options.interp = 1;
            matlabbatch{4}.spm.util.imcalc.options.dtype = 4;
            
            spm_jobman('run',matlabbatch);
            
        end
    end
    
end

