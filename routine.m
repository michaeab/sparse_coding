
%% first make the sample Gabor
imSize = 100;                           % image size: n X n
lamda = 5;                             % wavelength (number of pixels per cycle)
theta = 60;                              % grating orientation, relative to the vertical line moving clockwise
sigma = 10;                             % gaussian standard deviation in pixels
phase = .25;                            % phase (0 -> 1)
trim = .005;                             % trim off gaussian values smaller than this


[ gabor ] = makeGabor(imSize, lamda, theta, sigma, phase, trim)

%% get some basic stats from that gabor
[ fittedTheta, fittedGaborCenter, fittedLamda ] = fitGabor(gabor)