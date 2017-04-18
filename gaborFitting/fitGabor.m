function [ lamda, theta, sigma, phase, trim, horizontalShift, verticalShift ] = fitGabor(patch)

options = optimoptions('fmincon','Diagnostics','on','Display','iter','Algorithm','interior-point','MaxIter',40);

% estimate initial values
[ fittedTheta0, fittedLamda0, horizontalShift0, verticalShift0 ] = determineGaborInitialValues(patch);

sigma0 = 1;
phase0 = 0;
trim0 = 0.005;

prmVec0 = [ fittedLamda0 fittedTheta0 sigma0 phase0 trim0 horizontalShift0 verticalShift0]; 

f = @(prmVec)errorFuncGabor(patch, prmVec)

% bounds
vlb = [0 0 0 0 0.001 -7 -7];
vub = [100 180 10 1 0.01 7 7];

[prmVec, ~] = fmincon(f,prmVec0, [], [], [], [], vlb, vub, [], options);

lamda = prmVec(1);
theta = prmVec(2);
sigma = prmVec(3); 
phase = prmVec(4);
trim = prmVec(5);
horizontalShift = prmVec(6); 
verticalShift = prmVec(7);

end
    
