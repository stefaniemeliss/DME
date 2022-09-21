% read out the FWE cluster threshold for each contrast

clear all;

% define DME dir
DME_dir='/storage/shared/research/cinn/2018/MAGMOT/DME';

% add SPM dir
spm_dir=[DME_dir '/spm12'];
addpath(spm_dir);
spm fmri

% define where to save the code
load_dir = [DME_dir '/scripts/group_anal/glm1/t_tests'];

name_models = {'SWWS_D' 'SWWS_M' 'SWWS_E'};

% define groups
groups = {'control' 'reward' 'gambling'};

contrast_list = {1 2};
contrast_name = {'tcon_pos' 'tcon_neg'};

analysis_type = 'wholeBrain';
analysis_out_name = 'wholeBrain_FWEv';

% change command window maths format
format longG

%% loop through models, analysis type, and contrasts

for g = 1:length(groups)
    
    
    for n= 1:length(name_models)
        
        
        for c = 1:length(contrast_name)
            
            
            % load in template file for extent threshold estimation % USE SEPERATE FILES FOR ROI AND WHOLE BRAIN HERE %
            cd(load_dir);
            load DME_SecondLevel_ResultReport_wholeBrain.mat
            
            % 1. change SPM.mat file
            matlabbatch{1,1}.spm.stats.results.spmmat = {[DME_dir '/GLM/glm1/2nd-level/t_tests/' name_models{n} '/' groups{g} '/SPM.mat']};
            % 2. change contrast to extract data from
            current_contrast = contrast_list{c};
            matlabbatch{1,1}.spm.stats.results.conspec.contrasts = current_contrast;
            matlabbatch{1}.spm.stats.results.export = cell(1, 0); % do not extract any results at this point
            
            % 3. change other options
            matlabbatch{1}.spm.stats.results.conspec.threshdesc = 'FWE'; % adjust depending on ROI 'FWE' or whole brain analysis 'none'
            matlabbatch{1}.spm.stats.results.conspec.thresh = 0.05; % adjust depending on ROI 0.05 or whole brain analysis 0.001
            matlabbatch{1}.spm.stats.results.conspec.extent = 0; % adjust depending on ROI [FWEc] or whole brain analysis [k]
            matlabbatch{1}.spm.stats.results.conspec.conjunction = 1;
            matlabbatch{1}.spm.stats.results.units = 1;
            
            % 7. change file and extract results
            matlabbatch{1}.spm.stats.results.conspec.titlestr = '';
            matlabbatch{1}.spm.stats.results.export{1}.csv = true;
            matlabbatch{1}.spm.stats.results.export{2}.pdf = true;
            matlabbatch{1,1}.spm.stats.results.export{3}.tspm.basename = [contrast_name{c} '_thresholded_' analysis_out_name];
            
            % 8. save changed file & run batch
            cd(load_dir);
            eval(['save DME_SecondLevel_ResultReport_temp.mat matlabbatch']);
            eval(['load DME_SecondLevel_ResultReport_temp.mat matlabbatch']);
            spm_jobman('run', matlabbatch);
            
            % 9. change name of csv output file
            projectdir = '.';
            dinfo = dir( fullfile(projectdir, 'spm*.csv') );
            oldnames = {dinfo.name};
            
            for K = 1 : length(oldnames)
                this_name = oldnames{K};
                new_name = strrep(this_name,'spm_', [contrast_name{c} '_' analysis_out_name '_']);
                movefile( fullfile(projectdir, this_name), fullfile(projectdir, new_name) );
            end
            
            % 10. change name of pdf output files
            projectdir = '.';
            dinfo = dir( fullfile(projectdir, 'spm*.pdf') );
            oldnames = {dinfo.name};
            
            for K = 1 : length(oldnames)
                this_name = oldnames{K};
                new_name = strrep(this_name,'spm_', [contrast_name{c} '_' analysis_out_name '_']);
                movefile( fullfile(projectdir, this_name), fullfile(projectdir, new_name) );
            end
            
            
            % delete temp file
            delete(fullfile(load_dir, 'DME_SecondLevel_ResultReport_temp.mat'))
            
        end
        
    end
    
end



%% roi analysis

% define path with wfu toolbox and add
wfu_dir=[spm_dir '/toolbox/WFU_PickAtlas_3.0.5b/wfu_pickatlas'];
addpath(wfu_dir);