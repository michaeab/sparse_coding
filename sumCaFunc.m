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

% WEIGHT EACH BASIS VECTOR BY ITS WEIGHT
phiTimesA = bsxfun(@times,phi,a);

% DOT PRODUCT EACH BASIS VECTOR WITH EVERY OTHER BASIS VECTOR
eachPhiDotWithEachOtherPhi = sum(phi'*phiTimesA,2);

% DOT PRODUCT EACH PHI WITH ITSELF
phiTimesItself = sum(phi.^2);

% SUBTRACT THAT DOT PRODUCT
output = eachPhiDotWithEachOtherPhi-(a.*phiTimesItself)';

end