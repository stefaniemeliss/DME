%% SET-UPS

DME_dir='/storage/shared/research/cinn/2018/MAGMOT/DME';
beta_root=[DME_dir '/GLM/beta_series_correlation/1st-level'];
cd(beta_root);

% add SPM dir
spm_dir=[DME_dir '/spm12'];
addpath(spm_dir);

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

% define other variables to loop through
sides={'left' 'right'};
difficulty={'D' 'M' 'E'};
SW_files={'peak_1' 'peak_2' 'peak_3'};
WS_files={'peak_4' 'peak_5' 'peak_6'};
WS_ave={'peak_4__5__6'};
approach={'ave' 'only'};

%% loop over subjects
for s = 1:length(subjects)
%for s = 1:1
    
    % determine subject
    SUBJ_ID = subjects{s}
    
    % change directory into folder with the beta series functional connectivity maps
    beta_dir=[beta_root '/' SUBJ_ID '/betaseries'];
    cd(beta_dir);
    
    % compute for all sides
    for side = 1:length(sides)
        
        % compute for all difficulty levels
        for d = 1:length(difficulty)
            
            % compute using matching WS (e.g., only SW_D) or average WS map
            for a = 1:length(approach)
                
                % define WS image and output file name depending on approach
                if strcmp(approach{a}, 'ave')
                    WS_img = ['zfcmap_sphere5mm_' sides{side} '_' WS_files{d} '.nii,1'];
                    out=['con_zfcmap_sphere5mm_' sides{side} '_SWWS_' difficulty{d} '.nii'];
                else
                    WS_img = ['zfcmap_sphere5mm_' sides{side} '_peak_4__5__6.nii,1'];
                    out=['con_zfcmap_sphere5mm_' sides{side} '_SWWS_' difficulty{d} 'only.nii'];
                end
                
                % specify ImCalc %
                matlabbatch{1}.spm.util.imcalc.input = {
                    ['zfcmap_sphere5mm_' sides{side} '_' SW_files{d} '.nii,1']
                    WS_img
                    };
                matlabbatch{1}.spm.util.imcalc.output = out;
                matlabbatch{1}.spm.util.imcalc.outdir = {''};
                matlabbatch{1}.spm.util.imcalc.expression = 'i1-i2';
                matlabbatch{1}.spm.util.imcalc.var = struct('name', {}, 'value', {});
                matlabbatch{1}.spm.util.imcalc.options.dmtx = 0;
                matlabbatch{1}.spm.util.imcalc.options.mask = 0;
                matlabbatch{1}.spm.util.imcalc.options.interp = 1;
                matlabbatch{1}.spm.util.imcalc.options.dtype = 4;
                
                % run batch
                spm_jobman('run',matlabbatch);
                
            end
            
        end
        
    end
    
end
