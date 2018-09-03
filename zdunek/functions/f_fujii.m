% Function f_fujii (Fujii's method)
% (Spatial analysis of speckle activity, Sec 2.2. of Zudnek et al., 2014)
% Input:
%    I       array of images (grayscale)
% Output:
%    F       Fujii's index

function F = f_fujii(I)

F=[];
if(isempty(I) || size(I,3)<2)
    return;
end

if(~isa(I,'double'))
    I=double(I);
end

A1=I(:,:,1:end-1);
A2=I(:,:,2:end);

num=abs(A1-A2);
den=A1+A2;

F=sum(num./den,3);

end