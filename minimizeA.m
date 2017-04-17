function aNew = minimizeA(I,phi,a,lambda,sigma,numIter)

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

scaleAdot = 1;

for i = 1:numIter % FOR EACH ITERATION
   % CHANGE IN DERIVATIVE OF WEIGHTS
   aDot = equationFive(I,phi,a,lambda,sigma);
   % UPDATE WEIGHTS
   a = a+aDot'./scaleAdot;
   display(num2str(max(aDot)./scaleAdot));
end

aNew = a';

end