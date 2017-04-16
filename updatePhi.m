function deltaPhi = updatePhi(I,phi,a,eta)

% function deltaPhi = updatePhi(I,phi,a,eta)
%
% implements gradient descent algorithm itself
%
%
% example call: 
%               load('patches.mat');
%               testA = rand([144 192]);
%               testWeights = rand([1 192]);
%               testPatch = imPatches(:,:,1);
%               deltaPhi = updatePhi(testPatch(:),testA,testWeights,5);
% inputs: 
%         I      : image
%         phi    : M X N matrix of basis functions, where M is the length of
%                 each basis function and N is the number of functions
%         a      : 1 X N vector of weights for basis functions
%         lambda : learning rate: lambda/sigma_I=0.1, where sigma_I is the
%                 variance of the image pixels
%         eta    : learning rate

% RECONSTRUCT IMAGE USING PHI AND WEIGHTS
Ihat = phi*a';

% SUBTRACT FROM ACTUAL IMAGE TO GET RESIDUAL
residual = I-Ihat;

% ASSIGN A RESIDUAL VECTOR TO EACH BASIS FUNCTION
residualMatrix = repmat(residual,[1 size(phi,2)]);

% MULTIPLY EACH RESIDUAL BY THE WEIGHTS AND THE LEARNING RATE
deltaPhi = bsxfun(@times,residualMatrix,a);
deltaPhi = deltaPhi.*eta;

end