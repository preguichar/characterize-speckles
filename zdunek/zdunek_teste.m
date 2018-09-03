% Paper Zdunek et al. (2013)
% The biospeckle method for investigation of agricultural crops: a review

% Created on: 2018.06.06

clear all
close all
clc

% What should be done?
do_contrast=true;   % Global contrast (spatial/temporal)
do_thsp=false;      % THSP
do_fujii=false;     % Fujii & Generalized difference
do_lasca=true;      % LASCA (spatial/temporal)


% Add functions path
addpath('functions\');



% Load input file
% var: biospeckle
fileName='exp180613-estagio5L70';
temp_file=['speckleROI\',fileName,'.mat'];
load(temp_file);


% Number of experiments
temp_N=size(biospeckle,1);

% Biospeckle data with the analysis
biospeckleData=struct;


% 2.1. Global measurements of speckle activity
% 2.1.1. Spatial and temporal contrast
% 2.1.2. Time history of the speckle pattern (THSP)
% 2.1.3. Spatial-temporal speckle correlation technique -??

% 2.2. Spatial analysis of biospeckle activity
% 2.2.1. Fujii's method
% 2.2.2. Generalized difference
% 2.2.3. Laser speckle contrast analysis (LASCA)
% 2.2.4. Motion history image (MHI)
% 2.2.5. Analyss in spectral domains

fig=figure;
for i=1:temp_N
    % Get the name of the experiment
    biospeckleData(i).Name=biospeckle{i,1};
    
    % Convert 'biospeckle' data into matricial form
    temp_inputData=biospeckle{i,2}; % (1 x nFrames) struct with fields 'cdata' (rows x cols) & 'colormap'
    temp_inputData=struct2cell(temp_inputData);
    temp_inputData(2,:,:)=[]; % remove 'colormap' values
    temp_inputData=double(cell2mat(temp_inputData)); % get frames from 'cdata'
    
    % Number of frames
    temp_nFrames=size(temp_inputData,3);
    
    % Spatial and temporal contrast
    if(do_contrast)
        temp_step=10;
        
        biospeckleData(i).contrast_temporal=f_contrast(temp_inputData,1);
        biospeckleData(i).contrast_spatial=f_contrast(temp_inputData);
        biospeckleData(i).contrast_spatials=zeros(ceil(temp_nFrames/temp_step),1);
        for j=1:temp_step:temp_nFrames
            temp_idx=ceil(j/temp_step);
            biospeckleData(i).contrast_spatials(temp_idx)=f_contrast(temp_inputData(:,:,j));
        end
    end
    
    % Time History of the Speckle Pattern
    if(do_thsp)
        temp_step=20;
        temp_nCols=size(temp_inputData,2);
        
        temp_thsp=struct;
        for j=1:temp_step:temp_nCols
            temp_idx=ceil(j/temp_step);
            temp_thsp(temp_idx).coluna=j;
            [temp_thsp(temp_idx).thsp,...
                temp_thsp(temp_idx).COM,...
                temp_thsp(temp_idx).IM,...
                temp_thsp(temp_idx).AVD]=f_thsp(temp_inputData,j,1);
        end
        
        biospeckleData(i).thsp=temp_thsp;
        clear temp_thsp;
    end
    
    % Fujii's method
    % Generalized difference
    if(do_fujii)
        biospeckleData(i).fujii=f_fujii(temp_inputData);
        biospeckleData(i).genDiffA=f_genDiff(temp_inputData); % absolute
        biospeckleData(i).genDiffW=f_genDiff(temp_inputData,1); % weighted
        biospeckleData(i).genDiffS=f_genDiff(temp_inputData,2); % squared        
    end
    
    % LASCA
    if(do_lasca)
        biospeckleData(i).lascaS3=f_lasca(temp_inputData,0,3);
        biospeckleData(i).lascaS5=f_lasca(temp_inputData,0,5);
        biospeckleData(i).lascaS7=f_lasca(temp_inputData,0,7);
        biospeckleData(i).lascaT3=f_lasca(temp_inputData,1,3);
        biospeckleData(i).lascaT5=f_lasca(temp_inputData,1,5);
        biospeckleData(i).lascaT7=f_lasca(temp_inputData,1,7);
    end
end


break


% save(['speckleAnalysis\',fileName,'.mat'],'sv*');


% clear temp* i j k
rmpath('functions\');