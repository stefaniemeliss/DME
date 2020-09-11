% read out the FWE cluster threshold for each contrast


clear all;

% define DME dir
DME_dir='/storage/shared/research/cinn/2018/MAGMOT/DME';

% add SPM dir
spm_dir=[DME_dir '/spm12'];
addpath(spm_dir);
spm fmri

% define where to save the code
load_dir = [DME_dir '/scripts/group_anal/glm1/two_way_anova'];

name_models = {'SWWS' 'SW' 'WS' 'SWWS_only'};
contrast_list = {2 3 4 15 16};
contrast_name = {'MainEffectGroup' 'MainEffectDifficulty' 'InteractionEffect' 'Trendeffect_1' 'Trendeffect_2'};


% change command window maths format
format longG


for n= 1:length(name_models)
    
    % load in template file for FWEc estimation
    cd(load_dir);
    load DME_SecondLevel_glm1_two_way_ANOVA_FWEc_estimation.mat
    % change SPM.mat file
    matlabbatch{1,1}.spm.stats.results.spmmat = {[DME_dir '/GLM/glm1/2nd-level/two_way_anova/' name_models{n} '/SPM.mat']};
    % save batch file
    eval(['save DME_SecondLevel_glm1_two_way_ANOVA_FWEc_estimation.mat matlabbatch']);
     
    for c = 1:length(contrast_name)
        
        % 1. load in template file for FWEc estimation
        cd(load_dir);        
        load DME_SecondLevel_glm1_two_way_ANOVA_FWEc_estimation.mat
        
        % 2. change contrast to extract data from
        current_contrast = contrast_list{c};
        matlabbatch{1,1}.spm.stats.results.conspec.contrasts = current_contrast;
        
        % 3. save changed template
        eval(['save DME_SecondLevel_glm1_two_way_ANOVA_FWEc_estimation.mat matlabbatch']);
        
        % 4. run batch to extract FWEc
        eval(['load DME_SecondLevel_glm1_two_way_ANOVA_FWEc_estimation.mat matlabbatch']);
        spm_jobman('run', matlabbatch);
        
        FWEc = TabDat.ftr{5,2}(3) % correct information
        
        % 5. load in template file again
        cd(load_dir);
        load DME_SecondLevel_glm1_two_way_ANOVA_FWEc_estimation.mat
        
        % 6. change template to include the FWEc and extract results
        matlabbatch{1,1}.spm.stats.results.conspec.contrasts = current_contrast;
        matlabbatch{1,1}.spm.stats.results.conspec.extent = [FWEc];
        matlabbatch{1,1}.spm.stats.results.units = 1;
        matlabbatch{1,1}.spm.stats.results.export{1}.pdf = true;
        matlabbatch{1,1}.spm.stats.results.export{2}.csv = true;
        matlabbatch{1,1}.spm.stats.results.export{3}.tspm.basename = 'thresholded_wholeBrain_FWEc';
        
        % 7. save changed file & run batch
        cd(load_dir);
        eval(['save DME_SecondLevel_glm1_two_way_ANOVA_Resultreport.mat matlabbatch']);
        eval(['load DME_SecondLevel_glm1_two_way_ANOVA_Resultreport.mat matlabbatch']);
        spm_jobman('run', matlabbatch);
        
        % 8. change name of csv output file
        projectdir = '.';
        dinfo = dir( fullfile(projectdir, 'spm*.csv') );
        oldnames = {dinfo.name};
        
        for K = 1 : length(oldnames)
            this_name = oldnames{K};
            new_name = strrep(this_name,'spm_', [contrast_name{c} '_wholeBrain_FWEc_' ]);
            movefile( fullfile(projectdir, this_name), fullfile(projectdir, new_name) );
            delete(fullfile(projectdir, this_name))
            
        end
        
        % 9. change name of pdf output files
        projectdir = '.';
        dinfo = dir( fullfile(projectdir, 'spm*.pdf') );
        oldnames = {dinfo.name};
        
        for K = 1 : length(oldnames)
            this_name = oldnames{K};
            new_name = strrep(this_name,'spm_', [contrast_name{c} '_wholeBrain_FWEc_' ]);
            movefile( fullfile(projectdir, this_name), fullfile(projectdir, new_name) );
            delete(fullfile(projectdir, this_name))
            
        end
        
    end
    
end










