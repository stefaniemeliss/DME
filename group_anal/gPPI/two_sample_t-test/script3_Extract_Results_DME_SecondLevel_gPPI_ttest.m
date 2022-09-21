% read out the FWE cluster threshold for each contrast

clear all;

% define DME dir
DME_dir='/storage/shared/research/cinn/2018/MAGMOT/DME';

% add SPM dir
spm_dir=[DME_dir '/spm12'];
addpath(spm_dir);
spm fmri

% define where to save the code
load_dir = [DME_dir '/scripts/group_anal/gPPI/two_sample_t-test'];

model = {'SWWS_Donly' 'SWWS_Monly'};
contrast_list = {1 2};
contrast_name = {'C<R' 'R<C'};

sides={'left' 'right'};


% change command window maths format
format longG

%% loop through models, sides, and contrasts

% compute for all contrasts
for n= 1:length(model)
    
    for c = 1:length(contrast_name)
        
        % compute for all sides
        for s = 1:length(sides)
            
            % load in template file for extent threshold estimation
            cd(load_dir);
            load DME_SecondLevel_ResultReport_wholeBrain.mat
            
            % 1. change SPM.mat file
            spm_out = [DME_dir '/GLM/gPPI/2nd-level/two_sample_t-test/' model{n} '/' sides{s} '_peak'];
            matlabbatch{1,1}.spm.stats.results.spmmat = {[spm_out '/SPM.mat']};
            % 2. change contrast to extract data from
            current_contrast = contrast_list{c};
            matlabbatch{1,1}.spm.stats.results.conspec.contrasts = current_contrast;
            matlabbatch{1}.spm.stats.results.export = cell(1, 0); % do not extract any results at this point
            
            % specification for whole brain analysis
            matlabbatch{1}.spm.stats.results.conspec.threshdesc = 'none'; % adjust depending on ROI 'FWE' or whole brain analysis 'none'
            matlabbatch{1}.spm.stats.results.conspec.thresh = 0.0025; % exploratory analysis: 0.005 / 2 to account for multiple testing
            matlabbatch{1}.spm.stats.results.conspec.extent = 0; % adjust depending on ROI [FWEc] or whole brain analysis [k]
            matlabbatch{1}.spm.stats.results.conspec.conjunction = 1;
            matlabbatch{1}.spm.stats.results.units = 1;
            matlabbatch{1}.spm.stats.results.conspec.mask.none = 1;
            
            % 4. save changed temp file
            eval(['save DME_SecondLevel_ResultReport_temp.mat matlabbatch']);
            
            % 5. run batch to extract extent
            eval(['load DME_SecondLevel_ResultReport_temp.mat matlabbatch']);
            spm_jobman('run', matlabbatch);
            
            % extract cluster extent
            extent_val = TabDat.ftr{5,2}(3); % FWEc
            %extent_val = round(extent_val, 0)
            
            % 6. load in temp file again
            cd(load_dir);
            load DME_SecondLevel_ResultReport_temp.mat
            
            % 7. change temp file to include the FWEc/k extent and extract results
            matlabbatch{1}.spm.stats.results.conspec.titlestr = '';
            matlabbatch{1}.spm.stats.results.conspec.extent = [extent_val]; % adjust depending on ROI [FWEc] or whole brain analysis [k]
            matlabbatch{1}.spm.stats.results.export{1}.csv = true;
            matlabbatch{1}.spm.stats.results.export{2}.pdf = true;
            matlabbatch{1,1}.spm.stats.results.export{3}.tspm.basename = [contrast_name{c} '_' sides{s} '_peak_thresholded_wholeBrain_FWEc'];

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
                new_name = strrep(this_name,'spm_', [contrast_name{c} '_' sides{s} '_peak_thresholded_wholeBrain_FWEc']);
                movefile( fullfile(projectdir, this_name), fullfile(projectdir, new_name) );                
            end
            
            % 10. change name of pdf output files
            projectdir = '.';
            dinfo = dir( fullfile(projectdir, 'spm*.pdf') );
            oldnames = {dinfo.name};
            
            for K = 1 : length(oldnames)
                this_name = oldnames{K};
                new_name = strrep(this_name,'spm_', [contrast_name{c} '_' sides{s} '_peak_thresholded_wholeBrain_FWEc_']);
                movefile( fullfile(projectdir, this_name), fullfile(projectdir, new_name) );                
            end
            
            % delete temp file
            delete(fullfile(load_dir, 'DME_SecondLevel_ResultReport_temp.mat'))
            clear extent_val
            
        end
        
    end
    
end

