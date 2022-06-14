clear all;

% define DME dir
DME_dir='/storage/shared/research/cinn/2018/MAGMOT/DME';

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

% define where to load and save the code
load_dir = [DME_dir '/scripts/GLM/parametric_modulation/pm_mot/Regress_pm_mot/'];
save_dir = [DME_dir '/scripts/contrast/parametric_modulation/pm_mot/'];


for s = 1:length(subjects)
    
    cd(load_dir);
    
    % get information on regressors for first session
    eval(['load ' subjects{s} '_regress_pm_mot_s1.mat']);
    A = [];
    A = names;
    
    % get information on regressors for second session
    eval(['load ' subjects{s} '_regress_pm_mot_s2.mat']);
    B = [];
    B = names;
   
    
    reg = [];
    reg = [subjects{s}, A,B]
    
    temp = [];
    temp = reg;
    
    reg_names(s,1:length(reg)) = temp;
   
end


 cd(save_dir);
 eval(['save DME_names_regress_pm_mot.mat reg_names']);
