function error = errorFuncGabor(patch, prmVec)

% extract parameters from parameter vector
lamda = prmVec(1);
theta = prmVec(2);
sigma = prmVec(3); 
phase = prmVec(4);
trim = prmVec(5);
horizontalShift = prmVec(6); 
verticalShift = prmVec(7);

% make gabor
[ gabor ] = makeGabor(lamda, theta, sigma, phase, trim, horizontalShift, verticalShift);

% get error
error = sqrt(mean((patch-gabor).^2));

end