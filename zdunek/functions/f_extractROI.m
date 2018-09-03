% Function extract region of interest from a video sequence (ROI)
%    ROI is defined as a square region with size A.
% Input:
%    vidFile   Input video full path (array of string).
%    L         Size of ROI A = 2*L+1 (integer, default value: 70).
% Output:
%    roi       Region of interest (struct type with number of frames
%              elemetns). Grayscale.

function roi = f_extractROI(vidFile, varargin)

if(isempty(vidFile))
    roi=[];
    return;
end

if(~isempty(varargin) && isnumeric(varargin{1}))
    L=varargin{1};
else
    L=70;
end

% Load video file
vid=VideoReader(vidFile);

% Get video properties
nFrames=vid.NumberOfFrames;
vidHeight=vid.Height;
vidWidth=vid.Width;

% Preallocate movie structure
mov(1:nFrames)=struct('cdata',zeros(vidHeight,vidWidth,3,'uint8'),'colormap',[]);

% Read one frame at a time
for i=1:nFrames
    mov(i).cdata=read(vid,i);
end


selectROI=true;
fig=figure;
set(fig,'position',[100 150 vidWidth vidHeight]);

while(selectROI)
    % Select range of biospeckle
    imshow(mov(1).cdata, 'border','tight');
    set(fig,'Name','Tomate');
    text(10,20,'Select the center of the speckle window and press ENTER','color','y');
    text(10,40,'Only the last point will be considered.','color','y');
    text(10,vidHeight-15,vidFile,'color','w','interpreter','none');
    
    [x,y]=getpts(fig);
    x=round(x(end));
    y=round(y(end));
    if(isempty(x))
        continue;
    end
    
    
    % Confirm range of speckle
    I=mov(1).cdata;
    I(y-L:y+L,x-L:x-L+5,:)=repmat(reshape([0 255 0],[1 1 3]),[2*L+1 6 1]); % Left column
    I(y-L:y+L,x+L-5:x+L,:)=repmat(reshape([0 255 0],[1 1 3]),[2*L+1 6 1]); % Right column
    I(y-L:y-L+5,x-L:x+L,:)=repmat(reshape([0 255 0],[1 1 3]),[6 2*L+1 1]); % Upper row
    I(y+L-5:y+L,x-L:x+L,:)=repmat(reshape([0 255 0],[1 1 3]),[6 2*L+1 1]); % Bottom row
    
    
    imshow(I,'border','tight');
    text(10,20,'ROI is ok?','color','y');
    text(10,vidHeight-15,vidFile,'color','w','interpreter','none');
    hold on
    
    plot([vidWidth*0.5, vidWidth*0.5],[10,50],'-y','LineWidth',2);
    plot([vidWidth*0.3, vidWidth*0.5],[30,30],'-y','LineWidth',2);
    plot([vidWidth*0.5, vidWidth*0.7],[30,30],'-y','LineWidth',2);
    plot([vidWidth*0.32, vidWidth*0.3, vidWidth*0.32],[35,30,25],'-y','LineWidth',2);
    plot([vidWidth*0.68, vidWidth*0.7, vidWidth*0.68],[35,30,25],'-y','LineWidth',2);
    text(vidWidth*0.43,20,'Yes!','color','y');
    text(vidWidth*0.33,40,'(or press any key)','color','y');
    text(vidWidth*0.52,20,'No, take it again.','color','y');
    
    sv=waitforbuttonpress;
    if(sv==0) % Mouse click on the right side of the figure
        clicked=get(fig,'CurrentPoint');
        if(clicked(1)>vidWidth*0.5)
            continue;
        end
    end
    % Exit loop if: 1. Keybord was pressed (any key)
    %               2. Mouse click on the left side of the figure
    selectROI=false;
end

roi(1:nFrames)=struct('cdata',zeros(2*L+1,2*L+1,'uint8'),'colormap',gray(256));
for i=1:nFrames
    I=mov(i).cdata;
    roi(i).cdata=rgb2gray(I(y-L:y+L,x-L:x+L,:));
end

close(fig);


end