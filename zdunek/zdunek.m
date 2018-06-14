% Paper Zdunek et al. (2013)
% The biospeckle method for investigation of agricultural crops: a review

% Created on: 2018.06.06

clear all
close all
clc

% Load input file names
L=50;
expName='exp180613-estagio5';
pathVids=['..\data\Tomates\',expName,'\'];

n_tomates=20;
n_vistas=3;
fileName=cell(n_tomates*n_vistas,1);
for id_tomate=1:n_tomates
    for id_vista=1:n_vistas
        temp=(id_tomate-1)*n_vistas+id_vista;
        fileName{temp}=[pathVids,'tomate',num2str(id_tomate),96+id_vista,'.avi'];
    end
end


% Crop biospeckle ROI
biospeckle=cell(n_tomates*n_vistas,1);
for i=1:length(fileName)
    biospeckle{i}=f_extractROI(fileName{i},L);
end

save(['speckleROI\',expName,'L',num2str(L),'.mat'],'biospeckle');

clear temp* i