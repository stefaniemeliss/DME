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

% define where to save the code
save_dir =[DME_dir '/RealignPara'];
mkdir(save_dir);

% define important variables
criteria_movement = 3; %voxelsize
num_session = 2;

% create matrix to save results
Diff_find_population = repmat(NaN, [size(subjects,2), num_session]);


%% Loop over subjects
for s = 1 :length(subjects)
    
    % define load directory (functional files)
    load_dir = [preproc_dir '/' subjects{s} '/func/' ];
    
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

    % for each session
    for session = 1:num_session
        Data = []; % create empty matrix

        % load movement parameters and save them as data
        cd(load_dir);
        eval(['load rp_af' subjects{s} '-00' folder_num{session} '-00004-000004-01.txt']);
        eval(['Data = rp_af' subjects{s} '_00' folder_num{session} '_00004_000004_01']);
        
        % create NaN matrices in size of data
        Diff = repmat(NaN, size(Data,1), 2);
        Diff_criteria = repmat(NaN, size(Data,1), 2);
        
        % for all rows of data (i.e. functional volumes)
        for i = 1:size(Data,1)-1
            for j = 1:3
                % calculate relative movement
                Diff(i,j) = Data(i+1,j)-Data(i,j);
            end
        end

        % go through Diff (relative movement) and compare against criteria
        for i = 1:size(Diff,1)
            for j = 1:3
                if abs(Diff(i,j)) < criteria_movement
                    Diff_criteria(i,j) = 0;
                elseif abs(Diff(i,j)) >= criteria_movement    
                    Diff_criteria(i,j) = 1;
                end
            end
        end

        % check whether there is any movement above criteria in session
        Diff_find = find(abs(Diff) >= criteria_movement); 
        if size(Diff_find,1) >= 1            
            Diff_find_population(s, session) = 1;
        else
            Diff_find_population(s, session) = 0;
        end
        
        % save data for each subject & session
        cd(save_dir);
        eval(['save DME_RealignPara_' subjects{s} '_s' num2str(session) '.mat load_dir criteria_movement Diff Diff_criteria Diff_find Data']);
    end
end
    
cd(save_dir);    
save DME_RealignPara_population.mat criteria_movement Diff_find_population subjects