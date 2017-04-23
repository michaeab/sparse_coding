function a = minimize1(phi,I,lambda)

% function a = minimize1(phi,I,lambda)
%
% finds weights that minimize cost function

% BETA IS THE DOT PRODUCT OF EACH WEIGHT WITH THE IMAGE
beta = phi'*I;

% DOT PRODUCT EACH BASIS FUNCTION WITH EVERY OTHER BASIS FUNCTION 
alpha = phi'*phi;

% ADD LAMBDA TO ALPHA
lambdaIplusAlpha = lambda.*eye(size(alpha))+alpha;

% SOLVE FOR WEIGHTS
a = lambdaIplusAlpha\beta;

end