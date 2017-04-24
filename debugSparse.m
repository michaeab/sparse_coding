%% LOAD OUTDOOR DATA

% LOAD DATA
load('outdoors.mat');

% NUMBER OF BASIS FUNCTIONS
numBasis = 144;

%% IF USING GABOR TOY SET

numBasis = 144;

imPatches = image;

% RESHAPE IMAGE TO APPROPRIATE FORMAT
imPatches = reshape(imPatches,[size(imPatches,1) 12 12]);
imPatches = permute(imPatches,[2 3 1]);

%% IF USING NATURAL SCENES

% SCALE IMAGE PATCHES
imPatches = imPatches.*0.51;

%% LEAVE OUT PIXELS THAT ARE TOO BIG

% LEAVE OUT HIGHEST AND LOWEST 0.5%
imPatchQuantiles = quantile(imPatches(:),[0.005 0.995]);
imPatches(imPatches<imPatchQuantiles(1)) = imPatchQuantiles(1);
imPatches(imPatches>imPatchQuantiles(2)) = imPatchQuantiles(2);

%%

% PICK A FEW RANDOM WEIGHTS TO PLOT
weights2plot = [10 20 30 40 50 60 70];

% RANDOM IMAGE TO PLOT
ind2plot = randsample(1:10000,5);

% INITIALIZE COST FUNCTION COMPONENTS BEFORE AND AFTER
initError = [];
afterError = [];
initSparse = [];
afterSparse = [];

for j = 1:length(ind2plot) % RANDOMLY SAMPLE IMAGE PATCH
    % RANDOM IMAGE INDEX
    ind = ind2plot(j);
    % GRAB IMAGE PATCH
    I = imPatches(:,:,ind);
    % INITIALIZE BASIS FUNCTIONS
    phiInit = -1+2.*rand([144 numBasis]);
    phiInit = 0.1.*bsxfun(@rdivide,phiInit,sqrt(sum(phiInit.^2)));
    % INITIALIZE WEIGHTS
%    a = phiInit'*I(:);
    a = 1.*rand([numBasis 1]);
    % STD DEV OF IMAGE
    sigma_I = std(I(:));
    % LAMBDA TO SIGMA RATIO
    lambdaSigmaIratio = 0.1;
    % LAMBDA
    lambda = sigma_I.*lambdaSigmaIratio;
    % INITIAL ERROR AND SPARSENESS
    initError(end+1) = sum((I(:) - phiInit*a).^2) + lambda.*sum(log(1+a.^2)./log(2));
    initSparse(end+1) = sum(log(1+a.^2)./log(2));
    % NEW WEIGHTS
    aNew = minimize1(phiInit,I(:),lambda);
    % RECONSTRUCT IMAGE BASED ON OLD WEIGHTS
    reconstructedIold = phiInit*a;
    % RECONSTRUCT IMAGE BASED ON NEW WEIGHTS
    reconstructedI = phiInit*aNew;
    % ERROR AND SPARSENESS AFTER
    afterError(end+1) = sum((I(:) - phiInit*aNew).^2) + lambda.*sum(log(1+aNew.^2)./log(2));
    afterSparse(end+1) = sum(log(1+aNew.^2)./log(2));
    
    figure; 
    set(gcf,'Position',[598 549 1461 724]);
    
    subplot(2,3,3);
    imagesc(I);
    axis square; colormap gray;
    formatFigure('','','Original image');
    
    subplot(2,3,4);
    imagesc(reshape(reconstructedIold,[12 12]));
    axis square; colormap gray;
    formatFigure('','','Reconstructed image (old weights)');
    
    subplot(2,3,6);
    imagesc(reshape(reconstructedI,[12 12]));
    axis square; colormap gray;
    formatFigure('','','Reconstructed image (new weights)');
    
    initError./afterError
    initSparse./afterSparse
    
    pause;
    if j ~= length(ind2plot)        
       close;
    end
end

%%

clear;