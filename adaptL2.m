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


% SCALE FACTOR
scaleFactor = (runAvg./(sigma_goal.^2)).^alpha;

phiAdapt = bsxfun(@times,phiOld,scaleFactor);

end