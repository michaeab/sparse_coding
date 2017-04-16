function aNew = minimizeA(I,phi,a,lambda,sigma,numIter)

% function aNew = minimizeA(I,phi,a,lambda,sigma,numIter)
%
% minimizes weights for each image
%
% example call: 
%               load('patches.mat');
%               testA = rand([144 192]);
%               testWeights = rand([1 192]);
%               testPatch = imPatches(:,:,1);
%               aNew = minimizeA(testPatch(:),testA,testWeights,0.1,0.1,20);
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
   % CHANGE IN DERIVATIVE OF WEIGHTS
   aDot = equationFive(I,phi,a,lambda,sigma);
   % UPDATE WEIGHTS
   aNew = a'+aDot;
end

end