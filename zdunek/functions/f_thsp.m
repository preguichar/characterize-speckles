% Function thsp (time history of the speckle pattern)
% (Global measures of speckle activity, Sec 2.1. of Zudnek et al., 2014)
% Input:
%    I       input image or array of images (grayscale)
%    ind     index of the analyzed column (default: center column).
%    norm    if(norm==1) then compute the im and avd based on the
%            normalized co-occurrence matrix. For any other values of norm,
%            including null, the co-occurrence matrix without normalization
%            is adopted.
% Output:
%    thsp    time history of the speckle pattern
%    com     co-occurrence matrix of the thsp
%    im      inertia moment based on co
%    avd     absolute value of differences based on co

function [thsp, com, im, avd] = f_thsp(I,varargin)

if(isempty(I))
    return;
end

ind=-1; % default value
normaliza=false;
if(~isempty(varargin))
    if(isnumeric(varargin{1}))
        argin=varargin{1}(1);
        if(argin>0 && argin<=size(I,2))
            ind=argin;
        end
    end
    if(numel(varargin)>1 && varargin{2}==1)
        normaliza=true;
    end
end


if(~isa(I,'double'))
    I=double(I);
end


% Create THSP from I

nFrames=size(I,3);

if(ind==-1)
    ind=ceil(size(I,2)/2);
end

thsp=I(:,ind,:);
thsp=reshape(thsp,[size(I,1) nFrames]); % double

%    co      co-occurrence matrix of the thsp
%    coN     normalized co-occcurrence matrix of the thsp (sum(rowi)=1)
%    The one that is used to compute IM and AVD is returned in 'com'
co=graycomatrix(thsp,'NumLevels',256,'GrayLimits',[0 255]); % double
if(normaliza)
    coN=co./repmat(sum(co,2)+eps,[1 size(co,2)]);
    com=coN;
else
    com=co;
end

tempi=1:size(com,1); tempi=repmat(tempi',[1 size(com,2)]);
tempj=1:size(com,2); tempj=repmat(tempj,[size(com,1) 1]);
im=sum(sum(com.*(tempi-tempj).*(tempi-tempj)));
avd=sum(sum(com.*abs((tempi-tempj))));

end