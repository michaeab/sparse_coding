function output = biFunc(phi,I)

% function output = biFunc(phi,I)
%
% implements first part of equation 5 in the Olshausen and Field paper:
% term b_i
%
% example call: testA = [1 4 7 10;2 5 8 11;3 6 9 12]
%               I = [10;20;30]
%               output = biFunc(testA,I)
%
% inputs:
%         phi: M X N matrix of basis functions, where M is the length of
%              the basis functions and N is the number of basis functions
%         I  : image as a M X 1 vector, where M is also the length of the
%              basis functions

output = phi'*I;

end