%% checking number of trials per participant per session

clear all;
clc;

% define DME dir
DME_dir='/storage/shared/research/cinn/2018/MAGMOT/DME';

% cd to directory where regressors from glm1 are saved
regress_dir=[DME_dir '/scripts/GLM/glm1/Regress_glm1'];
cd(regress_dir);

subjects = {'KM13121601' 'KM13121602' 'KM13121604'...
    'KM13121701' 'KM13121702' 'KM13121703' 'KM13121704' 'KM13121801' 'KM13121802' 'KM13121803' 'KM13121804'...
    'KM13121901' 'KM13121902' 'KM13121903'              'KM13122001' 'KM13122002' 'KM13122003' 'KM13122004'...
    'KM14051201' 'KM14051202' 'KM14051203' 'KM14051204' 'KM14051301' 'KM14051302'              'KM14051304'...
    % 'KM14051401' ...
    'KM14051402' 'KM14051403' 'KM14051404' 'KM14051501' 'KM14051502' 'KM14051503' 'KM14051504'...
    'KM14051601'                                        'KM14090101' 'KM14090102' 'KM14090103' 'KM14090104'...
    'KM14090201' 'KM14090202'                           'KM14090301' 'KM14090302' 'KM14090303' 'KM14090304'...
    'KM14090401' 'KM14090402' 'KM14090403'              'KM14090501' 'KM14090502' 'KM14090503' 'KM14090504'};

% 'KM14051401'

for s = 1:length(subjects)
    
    % load in regressor file for first session
    load([subjects{s} '_regress_glm1_s1.mat']) 
    disp([subjects{s} '_regress_glm1_s1.mat'])
    
    % extract onsets
    SW_D = onsets{1,1}
    SW_M = onsets{1,2}
    SW_E = onsets{1,3}
    WS_D = onsets{1,8}
    WS_M = onsets{1,9}
    WS_E = onsets{1,10}
    
    % load in regressor file for second session
    load([subjects{s} '_regress_glm1_s2.mat']) % session 2
    disp([subjects{s} '_regress_glm1_s2.mat'])
    
    % extract onsets
    SW_D = {onsets{1,1}}
    SW_M = {onsets{1,2}}
    SW_E = {onsets{1,3}}
    WS_D = {onsets{1,8}}
    WS_M = {onsets{1,9}}
    WS_E = {onsets{1,10}}
    
end

%% saving onsets in .txt file

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
    % load in regressor file for first session
    load([subjects{s} '_regress_glm1_s1.mat'])
    disp([subjects{s} '_regress_glm1_s1.mat'])
    
    % extract onsets
    SW_D = {onsets{1,1}};
    SW_M = {onsets{1,2}};
    SW_E = {onsets{1,3}};
    WS_D = {onsets{1,8}};
    WS_M = {onsets{1,9}};
    WS_E = {onsets{1,10}};
    
    fileID = fopen(['onsets_' subjects{s} '_s1.txt'],'w');
    
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
    load([subjects{s} '_regress_glm1_s2.mat']) % session 2
    disp([subjects{s} '_regress_glm1_s2.mat'])
    
    % extract onsets
    SW_D = {onsets{1,1}};
    SW_M = {onsets{1,2}};
    SW_E = {onsets{1,3}};
    WS_D = {onsets{1,8}};
    WS_M = {onsets{1,9}};
    WS_E = {onsets{1,10}};
    
    fileID = fopen(['onsets_' subjects{s} '_s2.txt'],'w');
    
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
load('KM14051401_regress_glm1_s1.mat')
% extract onsets
SW_D = {onsets{1,1}};
SW_M = {onsets{1,2}};
SW_E = {onsets{1,3}};
WS_D = {onsets{1,7}};
WS_M = {onsets{1,8}};
WS_E = {onsets{1,9}};

fileID = fopen('onsets_KM14051401_s1.txt','w');
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

load('KM14090101_regress_glm1_s1.mat') %WS 3 3 3
% extract onsets
SW_D = {onsets{1,1}};
SW_M = {onsets{1,2}};
SW_E = {onsets{1,3}};
WS_D = {onsets{1,8}};
WS_M = {onsets{1,9}};
WS_E = {onsets{1,10}};

fileID = fopen('onsets_KM14090101_s1.txt','w');
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

load('KM14090402_regress_glm1_s1.mat') %SW 9 8 10 WS 2 2 2
% extract onsets
SW_D = {onsets{1,1}};
SW_M = {onsets{1,2}};
SW_E = {onsets{1,3}};
WS_D = {onsets{1,8}};
WS_M = {onsets{1,9}};
WS_E = {onsets{1,10}};

fileID = fopen('onsets_KM14090402_s1.txt','w');
formatSpec = '%2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f %2.3f \n'; %SW_D
[nrows,ncols] = size(SW_D);
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

load('KM14090403_regress_glm1_s1.mat') %9 SW_M
% extract onsets
SW_D = {onsets{1,1}};
SW_M = {onsets{1,2}};
SW_E = {onsets{1,3}};
WS_D = {onsets{1,8}};
WS_M = {onsets{1,9}};
WS_E = {onsets{1,10}};

fileID = fopen('onsets_KM14090403_s1.txt','w');
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

load('KM14090501_regress_glm1_s1.mat') %SW 10 9 8, WS 1 3 3
% extract onsets
SW_D = {onsets{1,1}};
SW_M = {onsets{1,2}};
SW_E = {onsets{1,3}};
WS_D = {onsets{1,8}};
WS_M = {onsets{1,9}};
WS_E = {onsets{1,10}};

fileID = fopen('onsets_KM14090501_s1.txt','w');
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

load('KM14090502_regress_glm1_s1.mat') %9 SW_E
% extract onsets
SW_D = {onsets{1,1}};
SW_M = {onsets{1,2}};
SW_E = {onsets{1,3}};
WS_D = {onsets{1,8}};
WS_M = {onsets{1,9}};
WS_E = {onsets{1,10}};

fileID = fopen('onsets_KM14090502_s1.txt','w');
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

load('KM14090504_regress_glm1_s1.mat') %WS 3 4 2
% extract onsets
SW_D = {onsets{1,1}};
SW_M = {onsets{1,2}};
SW_E = {onsets{1,3}};
WS_D = {onsets{1,8}};
WS_M = {onsets{1,9}};
WS_E = {onsets{1,10}};

fileID = fopen('onsets_KM14090504_s1.txt','w');
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

load('KM14090104_regress_glm1_s2.mat') % WS 4 3 2
% extract onsets
SW_D = {onsets{1,1}};
SW_M = {onsets{1,2}};
SW_E = {onsets{1,3}};
WS_D = {onsets{1,8}};
WS_M = {onsets{1,9}};
WS_E = {onsets{1,10}};

fileID = fopen('onsets_KM14090104_s2.txt','w');
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

load('KM14090401_regress_glm1_s2.mat') % 9 SW_D
% extract onsets
SW_D = {onsets{1,1}};
SW_M = {onsets{1,2}};
SW_E = {onsets{1,3}};
WS_D = {onsets{1,8}};
WS_M = {onsets{1,9}};
WS_E = {onsets{1,10}};

fileID = fopen('onsets_KM14090401_s2.txt','w');
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

load('KM14090402_regress_glm1_s2.mat')
% extract onsets
SW_D = {onsets{1,1}};
SW_M = {onsets{1,2}};
SW_E = {onsets{1,3}};
WS_D = {onsets{1,8}};
WS_M = {onsets{1,9}};
WS_E = {onsets{1,10}};

fileID = fopen('onsets_KM14090402_s2.txt','w');
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

load('KM14090501_regress_glm1_s2.mat')
% extract onsets
SW_D = {onsets{1,1}};
SW_M = {onsets{1,2}};
SW_E = {onsets{1,3}};
WS_D = {onsets{1,8}};
WS_M = {onsets{1,9}};
WS_E = {onsets{1,10}};

fileID = fopen('onsets_KM14090501_s2.txt','w');
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

%% move newly created onset files

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

% define beta_series_correlation dir
beta_dir=[DME_dir '/GLM/beta_series_correlation/1st-level'];
mkdir(beta_dir);


% loop over subjects

for s = 1:length(subjects)
    
    SUBJ_ID = subjects{s};
    
    % make new folder in beta_series_correlation dir
    sub_dir = fullfile(beta_dir, SUBJ_ID);
    mkdir(sub_dir);
    
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
    
    
    
    % loop over both sessions
    for sess = 1 : 2
        
        % create new folder
        sess_dir=fullfile(sub_dir, ['session' num2str(sess)]);
        mkdir(sess_dir);
        
        % copy preprocessed files
        copyfile(fullfile(preproc_dir, SUBJ_ID, 'func', ['swuaf' SUBJ_ID, '-00' folder_num{sess} '-*.nii']), sess_dir);        
        
        % copy motion regressors
        copyfile(fullfile(preproc_dir, SUBJ_ID, 'func', ['rp_af' SUBJ_ID, '-00' folder_num{sess} '-*.txt']), sess_dir);
        
        % move onset files
        movefile(fullfile(regress_dir, ['onsets_' SUBJ_ID '_s' num2str(sess) '.txt']), fullfile(sess_dir, ['onsets_s' num2str(sess) '.txt']) );

        
        
    end

    
    
    
end
