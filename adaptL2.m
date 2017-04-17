function phiAdapt = adaptL2(phiNew,phiOld,sigma_goal,alpha,runAvg)

% function phiAdapt = adaptL2(phiNew,phiOld,sigma_goal,alpha,runAvg)
%
% when basis functions are updated, need to adapt their L2 norm so the
% output variance of each weight is held at an appropriate level. 
%
% inputs:
%         phiNew    : basis functions that have just been updated
%         phiOld    : basis functions before updating
%         sigma_goal: intended std dev of coefficients for each weight
%         alpha     : part of formula: 0.01
%         runAvg    : running average

% GET L2 NORM OF BASIS FUNCTIONS BEFORE THEY WERE UPDATED
lOld = sqrt(sum(phiOld.^2));

% SCALE FACTOR
scaleFactor = (runAvg.^2./(sigma_goal.^2)).^alpha;

% TARGET L2 NORM 
lNewTgt = lOld.*scaleFactor;

% HOW MUCH NEED TO SCALE PHI TO REACH TARGET L2 NORM
scaleCur = sqrt((lNewTgt.^2)./sum(phiNew.^2));

phiAdapt = bsxfun(@rdivide,phiNew,scaleCur);

end