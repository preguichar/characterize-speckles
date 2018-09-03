% Function contrast
% (Global measures of speckle activity, Sec 2.1. of Zudnek et al., 2014)
% Input:
%    I       input image or array of images (grayscale)
%    type    0 for spatial contrast (default) &
%            1 for temporal contrast
%            any other value will be ignored, and spatial contrast will be
%            computed.
% Output:
%    c       contrast value

function c = f_contrast(I,varargin)

if(isempty(I))
    return;
end

if(isempty(varargin))
    type=0;
else
    type=varargin{1};
    if(type~=0 && type~=1)
        type=0;
    end
end

if(~isa(I,'double'))
    I=double(I);
end



if(type) % Compute temporal contrast
    
    % Temporal variance
    img=I;
    vart=var(img,0,3);
    c=1-sqrt(abs(1-mean2(vart)/(mean2(img))^2));
    
else % Compute spatial contrast
    
    % Time averaging
    if(size(I,3)>1)
        img=mean(I,3);
    else
        img=I;
    end
    
    sigma=std2(img);
    avg=mean2(img);
    c=1-sigma/avg;
    
end

end