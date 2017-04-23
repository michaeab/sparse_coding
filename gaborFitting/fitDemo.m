%% Fit Demonstration

% first make a gabor that will stand in for a sample basis function
                           % image size: n X n
lamda = 3;                             % wavelength (number of pixels per cycle)
theta = 12;                              % grating orientation, relative to the vertical line moving clockwise
sigma = 1.5;                             % gaussian standard deviation in pixels
phase = 0;                            % phase (0 -> 1)
trim = .005;                             % trim off gaussian values smaller than this

verticalShift = 0;
horizontalShift = 0;

[ sampleBasis ] = makeGabor(lamda, theta, sigma, phase, trim, horizontalShift, verticalShift);

% the actual output gabor is a vector, but for visualization of what it
% looks like convert it to a matrix
sampleBasisMatrix = vec2mat(sampleBasis,16)';
figure;
imagesc(sampleBasisMatrix)
title('Sample Basis')

%% now actually do the fit
[ fittedLamda, fittedTheta, fittedSigma, fittedPhase, fittedTrim, fittedHorizontalShift, fittedVerticalShift ] = fitGabor(sampleBasis);

% create gabor based on those fitted parameters to see how well we did
[ gabor ] = makeGabor(fittedLamda, fittedTheta, fittedSigma, fittedPhase, fittedTrim, fittedHorizontalShift, fittedVerticalShift);
figure;
imagesc(vec2mat(gabor,16)')
title('Fitted Gabor')