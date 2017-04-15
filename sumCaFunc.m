function output = sumCaFunc(phi,a)

% function output = sumCaFunc(phi,a)
%
% implements second term in equation 5 on page 608 of Olshausen and Field:
% sum of C_ij x a_j
%
% example call: 
%               testA = [1 4 7 10;2 5 8 11;3 6 9 12]
%               testWeights = [10 20 30 40]
%               output = sumCaFunc(testA,testWeights)
%
% inputs: 
%
%        phi: basis functions phi. This is a matrix. Each column of this
%             matrix is a basis function. So, phi is an M X N matrix, where
%             M is the length of the basis functions and N is the number of
%             basis functions.
%        a  : weights for each basis function. This is a 1 x n vector,
%             where n is the number of basis functions.

% GETTING PHIS IN VECTORIZED FORM
phiAll = phi(:)';
phiItself = repmat(phi,[size(phi,2) 1]);

% CREATING DIAGONAL MATRIX SO THAT EACH PHI IS NOT DOT-PRODUCTED WITH
% ITSELF
onesUnit = ones([size(phi,1) 1]);
diag1 = kron(eye(size(phi,2)),onesUnit);
diag2 = (diag1-1).*(-1);
phiItself = phiItself.*diag2;

% RESHAPE WEIGHTS
aMatrix = repmat(a,[size(phi,1) 1]);
aUnwrap = aMatrix(:);
a = aUnwrap';

% WEIGHT EACH BASIS VECTOR
phiAllWeighted = phiAll.*a;

% FINAL OUTPUT
output = phiAllWeighted*phiItself;
output = output';

end