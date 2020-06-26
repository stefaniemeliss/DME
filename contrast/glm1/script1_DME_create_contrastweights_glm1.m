clear all;

% define DME dir
DME_dir='/storage/shared/research/cinn/2018/MAGMOT/DME';

% add SPM dir
spm_dir=[DME_dir '/spm12'];
addpath(spm_dir);
spm fmri

% define directory to save
save_dir = [DME_dir '/scripts/contrast/glm1/'];
cd(save_dir)

% define regressor matrix
reg_m = {'10 10' '11 10' '9 11'};
reg_m_name = {'NoError' 'Full' '9_11'};

% there is a xlsx file saved containingbthe contrast weights on participant level
% depending on how the participant performed (e.g. if they made any errors or not), the design
% matrix looks slightly different
% different design matrices are saved in different sheets
% if a participant made errors in a session, there will be 11 regressors in a session
% if there were no errors, there will be 10 regressors per session
% errors are always assigned to contrast value of zero, so that '11 10' will be the same as '11 11'
% when processed by SPM as zeros are added to the end of the contrast vector as necessary
% this meanns that both '10 10' and '10 11' are the same
% and that '11 11' and '11_10' are the same

% one particpant is a special case as that person does not have any SW_M_S trials


for c = 1 :length(reg_m)
    
    % read in contrast weights from spread sheet
    A = xlsread('Contrast.xlsx',reg_m{c});
    
    % define names of contrasts
    consess{1}.tcon.name = 'SW_D';
    consess{2}.tcon.name = 'SW_M';
    consess{3}.tcon.name = 'SW_E';
    consess{4}.tcon.name = 'O_D_F';
    consess{5}.tcon.name = 'O_M_S';
    consess{6}.tcon.name = 'O_M_F';
    consess{7}.tcon.name = 'O_E_S';
    consess{8}.tcon.name = 'WS_D';
    consess{9}.tcon.name = 'WS_M';
    consess{10}.tcon.name = 'WS_E';
    consess{11}.tcon.name = 'SWWS_D';
    consess{12}.tcon.name = 'SWWS_M';
    consess{13}.tcon.name = 'SWWS_E';
    consess{14}.tcon.name = 'SWWS_Donly';
    consess{15}.tcon.name = 'SWWS_Monly';
    consess{16}.tcon.name = 'SWWS_Eonly';
    consess{17}.tcon.name = 'SW_DM';
    consess{18}.tcon.name = 'SW_DE';
    consess{19}.tcon.name = 'SW_ME';
    consess{20}.tcon.name = 'O_M_SF';
    consess{21}.tcon.name = 'O_S_ME';
    consess{22}.tcon.name = 'O_F_MD';
    consess{23}.tcon.name = 'SWWS';
    consess{24}.tcon.name = 'SWWS_DM';
    consess{25}.tcon.name = 'SWWS_DE';
    consess{26}.tcon.name = 'SWWS_ME';
    consess{27}.tcon.name = 'SW_quad';
    consess{28}.tcon.name = 'SWWS_quad';
    consess{29}.tcon.name = 'SWWS_quad_inv';
    consess{30}.tcon.name = 'SWWS_DM_E';
    consess{31}.tcon.name = 'SWWS_ME_D';
    consess{32}.tcon.name = 'SW_DM_E';
    consess{33}.tcon.name = 'SW_ME_D';
    consess{34}.tcon.name = 'SW_pos';
    consess{35}.tcon.name = 'SW_neg';
    consess{36}.tcon.name = 'SWWS_pos';
    consess{37}.tcon.name = 'SWWS_neg';
    
    
    % access contrast vector from spreadsheet
    for i = 1:37
        consess{i}.tcon.convec = A(i,:);
        consess{i}.tcon.sessrep = 'none';
        
    end

    % save .mat file with contrast weights and names
    filename = ['DME_contrasts_glm1_' reg_m_name{c} '.mat'];
    save(filename, 'consess')

    
end


