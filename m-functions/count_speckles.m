close all
clear all
clc

% Input Data Folder
temp_folderPath='../data/2018.04.10 - nocore/';


% Call GUI

% Ag02
temp_fileName='Ag02';
filePath=[temp_folderPath, temp_fileName, '.mat']; load(filePath);
gui_specklecounter(MI,temp_fileName);

% Gl03
temp_fileName='Gl03';
filePath=[temp_folderPath, temp_fileName, '.mat']; load(filePath);
gui_specklecounter(MI,temp_fileName);



% Clear temporary variables
clear temp_*



















% Input variables
%  N: number of fibers
%  nfin: number of frames
%  mI: average intensity for each frame
%  MI: intensity window for each frame