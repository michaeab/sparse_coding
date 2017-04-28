%%

% NUMBER OF ELEMENTS IN EACH PHI
numEl = 144;

% NUMBER OF PHI
numPhi = 144;

% INITIALIZE PHI
% phiInitTest = 0.1.*(min(curTestPatch)+(max(curTestPatch)-min(curTestPatch)).*rand([numEl numPhi]));

phiInitTest = 0.1.*(-1+2.*rand([numEl numPhi]));

% TEST PATCH INDEX
testPatchInd = 9000;

% GRAB A TEST PATCH
curTestPatch = imPatches(:,:,testPatchInd);
curTestPatch = curTestPatch(:);

% INITIALIZE WEIGHTS
initialA = phiInitTest'*curTestPatch;

% CONSTRUCT RESIDUAL USING INITIAL BASIS FUNCTIONS AND WEIGHTS
residual = curTestPatch-(phiInitTest*initialA);

% HOW MUCH EACH WEIGHT IS DRIVEN BY THE RESIDUAL
resDrive = phiInitTest'*residual;

sigma_I = std(curTestPatch);
% LAMBDA TO SIGMA RATIO
lambdaSigmaIratio = 0.14;
% LAMBDA
lambda = sigma_I.*lambdaSigmaIratio;

% HOW MUCH EACH WEIGHT IS DRIVEN BY SPARSENESS
aDrive = lambda.*Sderivative(initialA);

sum(resDrive-aDrive>0 & initialA>0)
sum(resDrive-aDrive<0 & initialA<0)
sum(resDrive>0 & initialA>0)
sum(resDrive<0 & initialA<0)

