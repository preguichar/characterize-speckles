% Function f_genDiff (Generalized difference)
% (Spatial analysis of speckle activity, Sec 2.2. of Zudnek et al., 2014)
% Input:
%    I       array of images (grayscale)
% Output:
%    GD      Generalized difference's value
%    type    default: absolute gen. difference (Zdunek et al., 2014, Eq. 4)
%            1: weighted gen. difference (Zdunek et al., 2014, Eq. 6)
%            2: squared gen. difference (Zdunek et al., 2014, Eq. 5)

function GD = f_genDiff(I,varargin)

GD=[];
if(isempty(I) || size(I,3)<2)
    return;
end

wGD=false;
sGD=false;
if(~isempty(varargin))
    argin=varargin{1}(1);
    if(argin==1)
        wGD=true;
    elseif(argin==2)
        sGD=true;
    end
end

if(~isa(I,'double'))
    I=double(I);
end

N=size(I,3);

for i=1:N-1
    A1=I(:,:,i);
    A2=I(:,:,i+1:end);
    
    A1rep=repmat(A1,[1 1 size(A2,3)]);
    if(~wGD && ~sGD)
        B=abs(A1rep-A2);
    else
        if(wGD)
            B=abs(A1rep-A2);
            wp=1./((i+1:N)-i);
            wp=reshape(wp,[1 1 numel(wp)]);
            wp=repmat(wp,[size(B,1) size(B,2) 1]);
            B=B.*wp;
        else % sGD
            B=A1rep-A2;
            B=B.*B;
        end
    end
    gd=sum(B,3);
    
    if(isempty(GD))
        GD=gd;
    else
        GD=GD+gd;
    end
end

end