function output = Sderivative(x)

% function output = Sderivative(x)
%
% implements third term in equation 5 in the Olshausen paper. 
%
% inputs:
%         x: any variable (in our case, a_i/sigma)

output = (2.*x)./((1+x.^2).*(log(2)));

end