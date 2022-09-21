% read out the FWE cluster threshold for each contrast


clear all;

% define DME dir
DME_dir='/storage/shared/research/cinn/2018/MAGMOT/DME';

% add SPM dir
spm_dir=[DME_dir '/spm12'];
addpath(spm_dir);
spm fmri

% define where to save the code
load_dir = [DME_dir '/scripts/group_anal/glm1/trend_effect_within_group'];

name_models = {'SWWS' 'SW' 'WS' 'SWWS_only'};
%name_models = {'SWWS'}; % debug

contrast_list = {1 2 3};
contrast_name = {'decrease_with_increasing_difficulty' 'increase_with_increasing_difficulty' 'quadratic'};
%contrast_list = {2}; % debug
%contrast_name = {'increase_with_increasing_difficulty'}; % debug

% define groups
group = {'control' 'reward' 'gambling'};
%group = {'reward'}; % debug

analysis_type = {'wholeBrain' 'ROI'};
analysis_out_name = {'wholeBrain_FWEc' 'ROI_FWEk'};
analysis_out_name = {'wholeBrain_FWEc' 'ROI_FWE0'};

% determine ROI dir and file
roi_dir=[DME_dir '/Masks'];
roi_file='ROI_Striatum_Pallidum.nii,1'; % note: this is the same as ROI_Striatum_Pallidum_bilateral_dilated_1.nii,1 but shorter naming is better for result report

% change command window maths format
format longG


%% loop through groups, models, analysis type, and contrasts


for g = 1:length(group)
    
    
    for t= 1:length(analysis_type)
        
        
        for n= 1:length(name_models)
            
            for c = 1:length(contrast_name)
                
                
                % load in template file for extent threshold estimation % USE SEPERATE FILES FOR ROI AND WHOLE BRAIN HERE %
                cd(load_dir);
                % 3. change other options depending on analysis_type
                if strcmp('ROI', analysis_type{t})
                    load DME_SecondLevel_ResultReport_ROI.mat
                else
                    load DME_SecondLevel_ResultReport_wholeBrain.mat
                end
                
                % 1. change SPM.mat file
                matlabbatch{1,1}.spm.stats.results.spmmat = {[DME_dir '/GLM/glm1/2nd-level/trend_effect_within_group/' name_models{n} '/' group{g} '/SPM.mat']};
                % 2. change contrast to extract data from
                current_contrast = contrast_list{c};
                matlabbatch{1,1}.spm.stats.results.conspec.contrasts = current_contrast;
                matlabbatch{1}.spm.stats.results.export = cell(1, 0); % do not extract any results at this point
                
                % 3. change other options depending on analysis_type
                if strcmp('ROI', analysis_type{t})
                    
                    % specification for ROI analysis
                    matlabbatch{1}.spm.stats.results.conspec.threshdesc = 'FWE'; % adjust depending on ROI 'FWE' or whole brain analysis 'none'
                    matlabbatch{1}.spm.stats.results.conspec.thresh = 0.05; % adjust depending on ROI 0.05 or whole brain analysis 0.001
                    matlabbatch{1}.spm.stats.results.conspec.extent = 0; % adjust depending on ROI [FWEc] or whole brain analysis [k]
                    matlabbatch{1}.spm.stats.results.conspec.conjunction = 1;
                    matlabbatch{1}.spm.stats.results.units = 1;
                    % specify mask
                    matlabbatch{1}.spm.stats.results.conspec.mask.image.name = {[roi_dir '/' roi_file]};
                    matlabbatch{1}.spm.stats.results.conspec.mask.image.mtype = 0; % inclusive
                    
                else
                    
                    % specification for whole brain analysis
                    matlabbatch{1}.spm.stats.results.conspec.threshdesc = 'none'; % adjust depending on ROI 'FWE' or whole brain analysis 'none'
                    matlabbatch{1}.spm.stats.results.conspec.thresh = 0.001; % adjust depending on ROI 0.05 or whole brain analysis 0.001
                    matlabbatch{1}.spm.stats.results.conspec.extent = 0; % adjust depending on ROI [FWEc] or whole brain analysis [k]
                    matlabbatch{1}.spm.stats.results.conspec.conjunction = 1;
                    matlabbatch{1}.spm.stats.results.units = 1;
                    matlabbatch{1}.spm.stats.results.conspec.mask.none = 1;
                    
                end
                
                % 4. save changed temp file
                eval(['save DME_SecondLevel_ResultReport_temp.mat matlabbatch']);
                
                % 5. run batch to extract extent
                eval(['load DME_SecondLevel_ResultReport_temp.mat matlabbatch']);
                spm_jobman('run', matlabbatch);
                
                % extract cluster extent depending in ROI or whole brain
                if strcmp('wholeBrain', analysis_type{t})
                    extent_val = TabDat.ftr{5,2}(3); % FWEc
                else
                    extent_val = TabDat.ftr{3,2}; % k
                    extent_val = 0;
                end
                
                extent_val = round(extent_val, 0)
                
                % 6. load in temp file again
                cd(load_dir);
                load DME_SecondLevel_ResultReport_temp.mat
                
                % 7. change temp file to include the FWEc/k extent and extract results
                matlabbatch{1}.spm.stats.results.conspec.titlestr = '';
                matlabbatch{1}.spm.stats.results.conspec.extent = [extent_val]; % adjust depending on ROI [FWEc] or whole brain analysis [k]
                matlabbatch{1}.spm.stats.results.export{1}.csv = true;
                matlabbatch{1}.spm.stats.results.export{2}.pdf = true;
                matlabbatch{1,1}.spm.stats.results.export{3}.tspm.basename = [contrast_name{c} '_' group{g} '_thresholded_' analysis_out_name{t}];
                
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
                    new_name = strrep(this_name,'spm_', [contrast_name{c} '_' group{g} '_' analysis_out_name{t} '_']);
                    movefile( fullfile(projectdir, this_name), fullfile(projectdir, new_name) );                    
                end
                
                % 10. change name of pdf output files
                projectdir = '.';
                dinfo = dir( fullfile(projectdir, 'spm*.pdf') );
                oldnames = {dinfo.name};
                
                for K = 1 : length(oldnames)
                    this_name = oldnames{K};
                    new_name = strrep(this_name,'spm_', [contrast_name{c} '_' group{g} '_' analysis_out_name{t} '_']);
                    movefile( fullfile(projectdir, this_name), fullfile(projectdir, new_name) );                    
                end
                
                
                % delete temp file
                delete(fullfile(load_dir, 'DME_SecondLevel_ResultReport_temp.mat'))
                clear extent_val
                
            end
            
        end
        
    end
    
    
end




