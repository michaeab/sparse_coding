function aDot = equationFive(I,phi,a,lambda,sigma)

% function aDot = equationFive(I,phi,a,lambda,sigma)
%
% implements all of equation 5 of Olshausen and Field paper

aDot = biFunc(phi,I) - sumCaFunc(phi,a) - (lambda./sigma).*Sderivative(a./sigma);

end