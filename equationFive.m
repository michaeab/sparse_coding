function aDot = equationFive(I,phi,a,lambda,sigma)

% function aDot = equationFive(I,phi,a,lambda,sigma)
%
% implements all of equation 5 of Olshausen and Field paper
%
% example call: 
%               load('patches.mat');
%               testA = rand([144 192]);
%               testWeights = rand([1 192]);
%               testPatch = imPatches(:,:,1);
%               aDot = equationFive(testPatch(:),testA,testWeights,0.1,0.1);
%
% inputs: 
%         I     : image
%         phi   : M X N matrix of basis functions, where M is the length of
%                 each basis function and N is the number of functions
%         a     : 1 X N vector of weights for basis functions
%         lambda: learning rate: lambda/sigma_I=0.1, where sigma_I is the
%                 variance of the image pixels
%         sigma : scaling factor: std dev of images

% aDot = biFunc(phi,I) - sumCaFunc(phi,a) - (lambda./sigma).*Sderivative(a'./sigma);

scaleDown = 1;

residual = I-(phi*a');

aDot = scaleDown.*((phi'*residual) - 14.*lambda.*Sderivative(a'));

end