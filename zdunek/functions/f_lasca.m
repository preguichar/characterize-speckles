% Function f_lasca (LASCA method)
% (Laser speckle contrast analysis, Sec 2.2. of Zudnek et al., 2014)
% Input:
%    I       array of images (grayscale)
%    type    0 for spatial contrast (default) &
%            1 for temporal contrast
%            any other value will be ignored, and spatial contrast will be
%            computed.
%    M       window size to compute contrast (integer value, default = 5).
%            Common values of M are 3, 5, and 7.
% Output:
%    O       Output image with LASCA values

function O = f_lasca(I, varargin)

% Initial checks
if(isempty(I))
    return;
end

if(isempty(varargin))
    type=0;
    M=5;
else
    type=varargin{1};
    if(type~=0 && type~=1)
        type=0;
    end
    
    if(numel(varargin)>1)
        M=varargin{2};
        if(~isnumeric(M) || M>size(I,1) || M>size(I,2))
            M=5;
        end
        M=floor(M);
    else
        M=5;
    end
end

if(~isa(I,'double'))
    I=double(I);
end


% LASCA:
%  type=0: Spatially derived contrast
%  type=1: Temporally derived contrast

M=floor(M/2);

nR=size(I,1);
nC=size(I,2);
nF=size(I,3);

% Padding (reflexive)
nR2=nR+M*2;
nC2=nC+M*2;
I2=zeros(nR2,nC2,nF);

I2(M+1:end-M,M+1:end-M,:)=I;
I2a=reshape(I2,[nR2, nC2*nF, 1]);
I2a(1:M,:)=flipud(I2a(M+1:2*M,:));
I2a(M+nR+1:end,:)=flipud(I2a(nR+1:M+nR,:));
for i=0:M-1
    I2a(:,M-i:nR2:end)=I2a(:,M+i+1:nR2:end);
    I2a(:,nR2-i:nR2:end)=I2a(:,nR2-2*M+i+1:nR2:end);
end

% Padded image
I2=reshape(I2a,[nR2, nC2, nF]);


% LASCA
lasca=zeros(nR,nC);
for i=1:nR
    for j=1:nC
        a=I2(i:i+2*M,j:j+2*M,:);
        lasca(i,j)=f_contrast(a,type);
    end
end


% Output
O=lasca;

end