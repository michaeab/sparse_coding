%%

lamda = 3;                             % wavelength (number of pixels per cycle)
theta = 45;                              % grating orientation, relative to the vertical line moving clockwise
sigma = 2;                             % gaussian standard deviation in pixels
phase = 0;                            % phase (0 -> 1)
trim = .005;                             % trim off gaussian values smaller than this

verticalShift = 2;
horizontalShift = 3;

[x, y]= meshgrid(smpPos(12,12));

numGab = 144;

x0 = linspace(-0.5,0.5,numGab);
x0 = Shuffle(x0);
y0 = linspace(-0.5,0.5,numGab);
y0 = Shuffle(y0);
freqCpd = linspace(2,4,numGab);
thetaDeg = linspace(0,360,numGab);
phaseDeg = 0.*ones([1 numGab]);

sigmaXdeg =  0.15.*ones([1 numGab]);
sigmaYdeg =  0.15.*ones([1 numGab]);

%%

for ii = 1:numGab
    [ gabor ] = gabor2D(x,y,x0(ii),y0(ii),freqCpd(ii),thetaDeg(ii),phaseDeg(ii),sigmaXdeg(ii),sigmaYdeg(ii),1,0);
    gabor = gabor(:);
    gabors(ii,:) = gabor;
end

figure;
set(gcf,'Position',[341 305 1695 1035]);
for i = 1:size(gabors,1)
   subplot(12,12,i);
   imagesc(reshape(gabors(i,:),[12 12]));
   axis square;
   colormap gray;
   set(gca,'XTick',[]);
   set(gca,'YTick',[]);
end


%%

for ii = 1:20000
    a=zeros(1,numGab);
    a(1:5)=randsample(0:0.01:1,5);
    a=Shuffle(a);
    
    image(ii,:)=(a*gabors);
    
end
