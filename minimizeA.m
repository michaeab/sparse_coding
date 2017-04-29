function [aNew,totalError,SprimeStore,aRealTime,aDotStore,sparseness,sse]= minimizeA(I,phi,a,lambda,numIter)

% function aNew = minimizeA(I,phi,a,lambda,sigma,numIter)
%
% minimizes weights for each image
%
% example call: 
%               load('patches.mat');
%               I = imPatches(:,:,1);
%               phiInit = 1.*(-1+2.*rand([144 192]));
%               a = phiInit'*I(:);
%               sigma_I = std(I(:));
%               lambdaSigmaIratio = 0.1;
%               lambda = sigma_I.*lambdaSigmaIratio;
%               aNew = minimizeA(I(:),phiInit,a',lambda,sigma_I,10);
%
% inputs: 
%         I      : image
%         phi    : M X N matrix of basis functions, where M is the length of
%                 each basis function and N is the number of functions
%         a      : 1 X N vector of weights for basis functions
%         lambda : learning rate: lambda/sigma_I=0.1, where sigma_I is the
%                 variance of the image pixels
%         sigma  : scaling factor: std dev of images
%         numIter: number of iterations to find minimum a_i

for i = 1:numIter % FOR EACH ITERATION
   % CHANGE IN DERIVATIVE OF WEIGHTS. aDot AND Sprime WILL BE N X 1
   % VECTORS, WHERE N IS THE NUMBER OF BASIS FUNCTIONS. NOTE THAT a IS
   % STILL A 1 X N VECTOR.
   [aDot, Sprime] = equationFive(I,phi,a,lambda);
   % STORE S-PRIME AND CHANGE IN WEIGHT
   aDotStore(:,i) = aDot;
   SprimeStore(:,i) = Sprime;
   
   % STORE WEIGHT BEFORE UPDATING
   aRealTime(:,i) = a;
   % UPDATE WEIGHTS. SINCE WEIGHTS ARE 1 X N AND aDot is N X 1, TRANSPOSE
   a = a+aDot';
   
   % STORE DIFFERENT TYPES OF ERROR
   totalError(i) = sum((I - phi*a').^2) + lambda.*sum(log(1+a.^2)./log(2));
   sparseness(i) = sum(log(1+a.^2)./log(2));
   sse(i) = sum((I - phi*a').^2);
end

% ASSIGN NEW WEIGHT AND TRANSPOSE TO BE CONSISTENT WITH INITIAL WEIGHTS
aNew = a';

end