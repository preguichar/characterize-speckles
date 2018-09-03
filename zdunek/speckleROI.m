% Paper Zdunek et al. (2013)
% The biospeckle method for investigation of agricultural crops: a review

% Created on: 2018.06.06

clear all
close all
clc

% Add functions path
addpath('functions\');

% Load input file names & crop ROI
L=70;
expName='exp180613-estagio5';
pathVids=['..\data\Tomates\',expName,'\'];


n_tomates=1;
n_vistas=3;


biospeckle=cell(n_tomates*n_vistas,2);

for id_tomate=1:n_tomates
    for id_vista=1:n_vistas
        temp=(id_tomate-1)*n_vistas+id_vista;
        fileName=[pathVids,'tomate',num2str(id_tomate),96+id_vista,'.avi'];
        
        biospeckle{temp,1}=['tomate',num2str(id_tomate),96+id_vista];
        biospeckle{temp,2}=f_extractROI(fileName,L);
    end
end



save(['speckleROI\',expName,'L',num2str(L),'.mat'],'biospeckle');







clear temp* i
rmpath('functions\');