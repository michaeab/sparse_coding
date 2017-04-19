lamda = 3;                             % wavelength (number of pixels per cycle)
theta = 45;                              % grating orientation, relative to the vertical line moving clockwise
sigma = 2;                             % gaussian standard deviation in pixels
phase = 0;                            % phase (0 -> 1)
trim = .005;                             % trim off gaussian values smaller than this

verticalShift = 2;
horizontalShift = 3;

lamdaValues=0.1:0.1:5;
lamdaValues=Shuffle(lamdaValues);
thetaValues=0:3.6:176.4;
thetaValues=Shuffle(thetaValues);
sigmaValues=0.1:.1:5;
sigmaValues=Shuffle(sigmaValues);
phaseValues=0:0.02:.98;
phaseValues=Shuffle(phaseValues);
trimValues=.005*ones(1,50);
verticalShiftValues=-5:0.2:4.8;
verticalShiftValues=Shuffle(verticalShiftValues);
horizontalShiftValues=-5:0.2:4.8;
horizontalShiftValues=Shuffle(horizontalShiftValues);

for ii = 1:100
    [ gabor ] = makeGabor(lamda, theta, sigma, phase, trim, horizontalShift, verticalShift);
    gabors(ii,:) = gabor;
end

for ii = 1:10000
    a=zeros(1,100);
    a(1:5)=randsample(1:100,5);
    a=Shuffle(a);
    
    image(ii,:)=(a*gabors);
    
end



