clear all;

% define DME dir
DME_dir='/storage/shared/research/cinn/2018/MAGMOT/DME';

% add SPM dir
spm_dir=[DME_dir '/spm12'];
addpath(spm_dir);
spm fmri

% define directory to save
save_dir = [DME_dir '/scripts/contrast/parametric_modulation/pm_mot/'];
cd(save_dir)

% define regressor matrix
reg_m = {'9 9' '10 9' '8 10'};
reg_m_name = {'NoError' 'Full' '8_10'};

% there is a xlsx file saved containing the contrast weights on participant level
% depending on how the participant performed (e.g. if they made any errors or not), the design
% matrix looks slightly different
% different design matrices are saved in different sheets
% if a participant made errors in a session, there will be 10 regressors in a session
% if there were no errors, there will be 9 regressors per session
% errors are always assigned to contrast value of zero, so that '10 9' will be the same as '10 10'
% when processed by SPM as zeros are added to the end of the contrast vector as necessary
% this meanns that both '9 9' and '9 10' are the same
% and that '10 10' and '10 9' are the same

% one particpant is a special case as that person does not have any SW_M_S trials


for c = 1 :length(reg_m)
    
    % read in contrast weights from spread sheet
    A = xlsread('Contrast.xlsx',reg_m{c});
    
    % define names of contrasts
    consess{1}.tcon.name = 'SW_mod';
    consess{2}.tcon.name = 'SWWS_mod';
    consess{3}.tcon.name = 'SWWS';
    
    % access contrast vector from spreadsheet
    for i = 1:3
        consess{i}.tcon.convec = A(i,:);
        consess{i}.tcon.sessrep = 'none';
    end

    % save .mat file with contrast weights and names
    filename = ['DME_contrasts_pm_mot_' reg_m_name{c} '.mat'];   
    save(filename, 'consess')

    
end


