% Function contrast
% (Global measures of speckle activity)
% Input:
%    I       input image or array of images (grayscale)
%    type    0 for spatial contrast &
%            1 for temporal contrast
% Output:
%    c       contrast value

function c = f_contrast(I,type)

c=[];

if(type) % Compute temporal contrast
    
    
    
    
else % Compute spatial contrast
    
    % Time averaging
    if(size(I,3)>1)
        img=mean(I,3);
    end
    
    sigma=sqrt(var(var(img)));
    avg=mean2(img);
    c=1-sigma/avg;
    
end

end