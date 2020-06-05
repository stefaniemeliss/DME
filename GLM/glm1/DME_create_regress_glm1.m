clear all;

% define DME dir
DME_dir='/storage/shared/research/cinn/2018/MAGMOT/DME';

% add SPM dir
spm_dir=[DME_dir '/spm12'];
addpath(spm_dir);
spm fmri

% define where to save the code
save_dir = [DME_dir '/scripts/GLM/glm1/Regress_glm1/'];
mkdir(save_dir);

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
    
    
    for sess = 1 : 2
        
        % define directory where to find the files with experimental data
        load_dir = [DME_dir '/Behaviour/' subjects{s} '/'];
        cd(load_dir);
        
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        % load experimental data
        eval(['load ' subjects{s} '_wksp_sess' num2str(sess) '.mat trials2 watch_num outcome_events box_on_time cue_on_time outcome_on_time iti_on_time start_time']);
        % save it in data
        data1 = [trials2 outcome_events watch_num cue_on_time-start_time outcome_on_time-start_time iti_on_time-start_time];
        
        A1 = []; % create empty matrix
        
        % for all trials that are not NaN, copy data to matrix A1
        for i = 1:size(data1,1)
            if data1(i,1) >= 1
                A1 = [A1; data1(i,:)];
            end
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        % create empty objects for all regressors
        SW_D = [];
        SW_M = [];
        SW_E = [];
        SW = [];
        
        SW_D_F =  [];
        SW_M_S =  [];
        SW_M_F =  [];
        SW_E_S =  [];
        SW_M_SF = [];
        
        WS_D = [];
        WS_M = [];
        WS_E = [];
        WS = [];
        
        Err = [];
        Dur_Err = [];
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        % loop through A1 to assign a trial type given data
        
        for i = 1:size(A1,1)
            if A1(i,6) == 1 % valid trial
                if A1(i,3) == 1 % indicates stopwatch trials
                    if A1(i,4) == 1 % difficult
                        SW_D =  [SW_D; A1(i,8)];
                        if A1(i,7) >= 4995 && A1(i,7) <= 5005 % allowed response window
                            % participants never succeeded in difficult trials
                        else
                            % add onset of this trial to stopwatch diffiult failure
                            SW_D_F =  [SW_D_F; A1(i,9)];
                        end
                        
                    elseif A1(i,4) == 2 % moderate
                        SW_M =  [SW_M; A1(i,8)];
                        if A1(i,7) >= 4995 && A1(i,7) <= 5005 % allowed response window
                            % add onset of this trial to stopwatch moderate success
                            SW_M_S =  [SW_M_S; A1(i,9)];
                        else
                            % add onset of this trial to stopwatch moderate failure
                            SW_M_F =  [SW_M_F; A1(i,9)];
                        end
                        
                    elseif A1(i,4) == 3 % easy
                        SW_E =  [SW_E; A1(i,8)];
                        if A1(i,7) >= 4995 && A1(i,7) <= 5005 % allowed response window
                            % add onset of this trial to stopwatch easy success
                            SW_E_S =  [SW_E_S; A1(i,9)];
                        else
                            % participants always succeeded on easy trials
                        end
                    end
                elseif A1(i,3) == 2 % indicates watchstop trials
                    if A1(i,4) == 1 % difficult
                        % add onset of this trial to watchstop diffiult
                        WS_D =  [WS_D; A1(i,8)];
                    elseif A1(i,4) == 2 % moderate
                        % add onset of this trial to watchstop moderate
                        WS_M =  [WS_M; A1(i,8)];
                    elseif A1(i,4) == 3 % easy
                        % add onset of this trial to watchstop easy
                        WS_E =  [WS_E; A1(i,8)];
                    end
                end
            else % if A1(:,6) is not 1 --> error
                Err =  [Err; A1(i,8)]; % onset
                Dur_Err =  [Dur_Err; A1(i,10)-A1(i,8)]; %%box_on_time --> duration
            end
        end
        
        % combine onset objects
        WS = [WS_D; WS_M; WS_E];
        SW = [SW_D; SW_M; SW_E];
        SW_M_SF = [SW_M_S; SW_M_F];
        
        % create cell containing the onsets for each event
        Onset_pre = [];
        Onset_pre{1} = SW_D';
        Onset_pre{2} = SW_M';
        Onset_pre{3} = SW_E';
        Onset_pre{4} = SW_D_F';
        Onset_pre{5} = SW_M_S';
        Onset_pre{6} = SW_M_F';
        Onset_pre{7} = SW_E_S';
        Onset_pre{8} = WS_D';
        Onset_pre{9} = WS_M';
        Onset_pre{10} = WS_E';
        Onset_pre{11} = Err';
        
        % create cell containing the durations for each event
        Duration_pre = [];
        Duration_pre{1} = 1.5*ones(1,length(SW_D));
        Duration_pre{2} = 1.5*ones(1,length(SW_M));
        Duration_pre{3} = 1.5*ones(1,length(SW_E));
        Duration_pre{4} = 2.3*ones(1,length(SW_D_F));
        Duration_pre{5} = 2.3*ones(1,length(SW_M_S));
        Duration_pre{6} = 2.3*ones(1,length(SW_M_F));
        Duration_pre{7} = 2.3*ones(1,length(SW_E_S));
        Duration_pre{8} = 1.5*ones(1,length(WS_D));
        Duration_pre{9} = 1.5*ones(1,length(WS_M));
        Duration_pre{10} = 1.5*ones(1,length(WS_E));
        Duration_pre{11} = Dur_Err';
        
        % name the events
        Name_pre = {'SW_D' 'SW_M' 'SW_E' 'SW_D_F' 'SW_M_S' 'SW_M_F' 'SW_E_S' 'WS_D' 'WS_M' 'WS_E' 'Err'};
        
        % for each event transfer infos about onset, duration, and name into new cell object
        onsets = [];
        durations = [];
        names = [];
        j = 1;
        for i = 1:length(Name_pre)
            if ~isempty(Onset_pre{i})
                onsets{j} = Onset_pre{i};
                durations{j} = Duration_pre{i};
                names{j} = Name_pre{i};
                j = j+1;
            end
        end
        
        % save onset, duration and name of regressor in .mat file
        cd(save_dir);
        eval(['save '  subjects{s} '_regress_glm1_s' num2str(sess) '.mat names onsets durations']);
        
        
        % additionally, create a cell object A2 to save data in .txt format
        n = length(A1);
        C    = cell(1, n)';
        C(:) = {subjects{s}};
        A2 = num2cell(A1);
        A2 = [C A2];
        
        % save to .txt file
        fileID = fopen([ subjects{s} '_experiment_data_s' num2str(sess) '.txt'],'w');
        formatSpec = '%s \t %d \t %d \t %d \t %d \t %g \t %d \t %d \t %2.4f \t %2.4f \t %2.4f \n';
        [nrows,ncols] = size(A2);
        for row = 1:nrows
            fprintf(fileID,formatSpec,A2{row,:});
        end
        fclose(fileID);
        
    end
end


