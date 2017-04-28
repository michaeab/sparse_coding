function [g G] = gabor2D(x,y,x0,y0,freqCpd,thetaDeg,phaseDeg,sigmaXdeg,sigmaYdeg,bNormalize,bPLOT)         

% function [g G] = gabor2D(x,y,x0,y0,freqCpd,phaseDeg,thetaDeg,sigmaXdeg,sigmaYdeg,bNormalize,bPLOT)         
%
%   example call:  [x y]= meshgrid(smpPos(64,64));
%                  G = gabor2D(x,y,0,0,3,0,0,.15,.15,1,1);    
%
% implementation based on Geisler_GaborEquations.pdf in /VisionNotes
%
% x:          x position  in visual degrees [nxm] matrix
%              if [   ]-> 1 deg patch size, 128 sampPerDeg
%              if [  n]-> 1 deg patch size,   n sampPerDeg
%              if [1xn]-> x(end)-x(1) patch size, length(x) samples
% y:          y position  in visual degrees [nxm] matrix
% x0:         x position  of gabor center
% y0:         y position  of gabor center
% freqCpd:    frequency   in cycles per deg
% thetaDeg:   orientation in deg
% phaseDeg:   phase       in deg
% sigmaXdeg:  standard deviation of spatial gaussian envelope in bandpass direction
% sigmaYdeg:  standard deviation of spatial gaussian envelope in low pass direction
% bNormalize: 1 -> normalize to vector magnitude of 1
%             0 -> don't
% bPLOT:      1 -> plot
%             0 -> not
% %%%%%%%%%%%
% g:          gabor

if ~exist('bPLOT','var') || isempty(bPLOT) bPLOT = 0; end
if isempty(x) || isempty(y)
   if isempty(x)
   [x y] = meshgrid(samplePositions(128,128));    
   elseif isscalar(x)
   [x y] = meshgrid(samplePositions(x,x));
   elseif isvector(x)
   [x y] = meshgrid(x);    
   elseif ismatrix(x)
   [x y] = meshgrid(unique(x));    
   end
end
if isvector(x) && isvector(y) 
   [x y]=meshgrid(x,y); 
end



thetaRad = thetaDeg.*pi./180;

% ROTATED POSITIONS: apply rotation matrix
xp        =  (x-x0).*cos(thetaRad) + (y-y0).*sin(thetaRad);
yp        = -(x-x0).*sin(thetaRad) + (y-y0).*cos(thetaRad);

% GABOR
g = exp(-0.5.*(xp./sigmaXdeg).^2)  .* ...
    exp(-0.5.*(yp./sigmaYdeg).^2)  .* ...
    cos( (2.*pi.*freqCpd.*xp) + phaseDeg.*pi./180);
    
% NORMALIZE TO MAGNITUDE OF 1
if bNormalize
    g = g./sqrt(sum(g(:).^2));
end

% COMPUTE OCTAVE BANDWIDTH AND ORIENTATION BANDWIDTH
BWoct = sigma2bandwidthOct(freqCpd,sigmaXdeg);
BWort = sigma2bandwidthOrt(freqCpd,sigmaYdeg);

% FFT OF GABOR
if nargout > 1
    G = fftshift(fft2(fftshift(g)))./sqrt(numel(g));
end

if bPLOT
   %%%%%%%%%%%%%%%%%%%%%%%
   % PLOT GABOR IN SPACE %
   %%%%%%%%%%%%%%%%%%%%%%%
   figure('position',[411  523  1014  531]);
   s1=subplot(1,2,1); hold on
   surf(x,y,g,'edgecolor','none','facealpha',.9);
   formatFigure('X (deg)','Y (deg)','Space',0,0,18,14);
   axis square;
   grid on
   % view([-39    16]);
   view([0 90]);
%    rotate3d
   axis xy
   xlim(minmax(x));
   ylim(minmax(y));
   caxis(max(abs(g(:))).*[-1 1]);
   zlim(max(abs(g(:))).*[-1 1]);
   
   % COMPUTE FOURIER TRANSFORM
   G = fftshift(fft2(fftshift(g)))./sqrt(numel(g));
   
   %%%%%%%%%%%%%%%%%%%%%%%%%%%
   % PLOT GABOR IN FREQUENCY %
   %%%%%%%%%%%%%%%%%%%%%%%%%%%
   subplot(1,2,2);
   surf(length(x).*x(1,:),length(y).*y(:,1)',abs(G),'edgecolor','none');
   formatFigure('U (cpd)','V (cpd)','Frequency',0,0,18,14);
   axis square;
   axis tight;
   axis xy
   view([0 90]);
   cb = colorbar;
   
   figure(gcf); suptitle(['BW_{oct}=' num2str(BWoct,2) ...
                ', BW_{\theta}=' num2str(BWort.*180./pi,2) ' deg'  ...
                ', \Theta=' num2str(thetaDeg,3) ...
                ', \Phi=' num2str(phaseDeg,3)],22);
   set(cb,'position',[ 0.9159    0.1714    0.0247    0.6405]);
   subplot(s1);
   colormap gray(256)
end
