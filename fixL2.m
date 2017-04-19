function [phiAdapt,scaleFactor] = fixL2(phiOld,phiNew)

% function [phiAdapt,scaleFactor] = fixL2(phiOld,phiNew)
%
% when basis functions are updated, need to adapt their L2 norm so the
% output variance of each weight is held at an appropriate level. 
%
% inputs:
%         phiNew    : basis functions that have just been updated
%         phiOld    : basis functions before updating

% SCALE FACTOR
phiOldL2 = sqrt(sum(phiOld.^2));
phiNewL2 = sqrt(sum(phiNew.^2));
scaleFactor = 1.*(phiOldL2./phiNewL2);

phiAdapt = bsxfun(@times,phiNew,scaleFactor);

end