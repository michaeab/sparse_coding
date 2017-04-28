function [aDot, Sprime] = equationFive(I,phi,a,lambda)

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

% phi: M X N MATRIX OF BASIS FUNCTIONS, WHERE M IS THE LENGTH OF EACH BASIS
% FUNCTION AND N IS THE NUMBER OF FUNCTIONS. a: is a 1 X N VECTOR OF
% WEIGHTS FOR THE BASIS FUNCTIONS, HENCE THE TRANSPOSE. residual SHOULD BE
% M X 1 VECTOR
residual = I-(phi*a');

% aDot WILL BE AN N X 1 VECTOR OF WEIGHT CHANGES
aDot = scaleDown.*((phi'*residual)) - lambda.*Sderivative(a');

Sprime = Sderivative(a');

end