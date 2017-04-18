function [ gabor ] = makeGabor(lamda, theta, sigma, phase, trim, horizontalShift, verticalShift)

%% make sample gabor

% initial parameters
%imSize = 100;                           % image size: n X n
%lamda = 5;                             % wavelength (number of pixels per cycle)
%theta = 60;                              % grating orientation, relative to the vertical line moving clockwise
%sigma = 10;                             % gaussian standard deviation in pixels
%phase = .25;                            % phase (0 -> 1)
%trim = .005;                             % trim off gaussian values smaller than this


imSize = 12;
% go on to define the gabor based on these initial parameters
X = 1:imSize;                           % X is a vector from 1 to imageSize
X0 = (X / imSize) - .5;      % rescale X -> -.5 to .5
sinX = sin(X0 * 2*pi);
freq = imSize/lamda;                    % compute frequency from wavelength
Xf = X0 * freq * 2*pi;                  % convert X to radians: 0 -> ( 2*pi * frequency)
sinX = sin(Xf) ;                        % make new sinewave                      % plot in red
phaseRad = (phase * 2* pi);             % convert to radians: 0 -> 2*pi
sinX = sin( Xf + phaseRad) ;            % make phase-shifted sinewave

% pad in either direction
dx = X0(2)-X0(1);
X0 = horzcat(-100:dx:(min(X0)-dx),X0,(max(X0)+dx):dx:100);


[Xm Ym] = meshgrid(X0, X0); 

Xf = Xm * freq * 2*pi;
grating = sin( Xf + phaseRad);    
thetaRad = (theta / 360) * 2*pi;        % convert theta (orientation) to radians
Xt = Xm * cos(thetaRad);                % compute proportion of Xm for given orientation
Yt = Ym * sin(thetaRad);                % compute proportion of Ym for given orientation
XYt = [ Xt + Yt ];                      % sum X and Y components
XYf = XYt * freq * 2*pi;                % convert to radians and scale by frequency
grating = sin( XYf + phaseRad);                   % make 2D sinewave

s = sigma / imSize;                     % gaussian width as fraction of imageSize
Xg = exp( -( ( (X0.^2) ) ./ (2* s^2) ));% formula for 1D gaussian
Xg = normpdf(X0, 0, (20/imSize)); Xg = Xg/max(Xg); 

gauss = exp( -(((Xm.^2)+(Ym.^2)) ./ (2* s^2)) ); % formula for 2D gaussian

gauss(gauss < trim) = 0;                 % trim around edges (for 8-bit colour displays)
gabor = grating .* gauss;                % use .* dot-product
% offset the gabor to have it not centered at 0
%gabor = horzcat(gabor, zeros(100,100));
%gabor = vertcat(gabor, zeros(100,200));
gabor = gabor(1196+verticalShift:1207+verticalShift,1196-horizontalShift:1207-horizontalShift);
%figure;
%imagesc(gabor);
gabor = gabor(:);

end