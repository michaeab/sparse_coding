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
ind2plot = randsample(1:20000,5);

for j = 1:length(ind2plot) % RANDOMLY SAMPLE IMAGE PATCH
    % RANDOM IMAGE INDEX
    ind = ind2plot(j);
    % GRAB IMAGE PATCH
    I = imPatches(:,:,ind);
    % INITIALIZE BASIS FUNCTIONS
    phiInit = 0.01.*(-1+2.*rand([144 numBasis]));
%    phiInit = 0.5.*bsxfun(@rdivide,phiInit,sqrt(sum(phiInit.^2)));
    % INITIALIZE WEIGHTS
    a = phiInit'*I(:);
%    a = 2.*min(a(:))+10.*(max(a(:))-min(a(:))).*rand(size(a));
    % STD DEV OF IMAGE
    sigma_I = std(I(:));
    % LAMBDA TO SIGMA RATIO
    lambdaSigmaIratio = 0.14;
    % LAMBDA
    lambda = sigma_I.*lambdaSigmaIratio;
    % NEW WEIGHTS
    [aNew, totalError,~,~,~, sparseness,sse] = minimizeA(I(:),phiInit,a',lambda,sigma_I,100);
    % RECONSTRUCT IMAGE BASED ON OLD WEIGHTS
    reconstructedIold = phiInit*a;
    % RECONSTRUCT IMAGE BASED ON NEW WEIGHTS
    reconstructedI = phiInit*aNew;
    [aNewHist, aNewBins] = hist(aNew,20);
    aNewHist = aNewHist./length(aNew);
    [aOldHist, aOldBins] = hist(a,20);
    aOldHist = aOldHist./length(a);
    
    figure; 
    set(gcf,'Position',[598 549 1461 724]);
    
    subplot(2,3,1);
    plot(totalError,'LineWidth',1.5);
    axis square;
    formatFigure('Iteration','Cost',['Reduce cost by ' num2str(totalError(1)/totalError(end))]);
    set(gca,'LineWidth',1.5);
    
    subplot(2,3,2);
    plot(sparseness,'LineWidth',1.5);
    axis square;
    formatFigure('Iteration','Sparseness');
    set(gca,'LineWidth',1.5);
    
%     subplot(2,3,5);
%     plot(sse,'LineWidth',1.5);
%     axis square;
%     formatFigure('Iteration','Residual');
%     set(gca,'LineWidth',1.5);
    
    subplot(2,3,5);
    plot(aNewBins,aNewHist,'LineWidth',1.5); hold on;
    plot(aOldBins,aOldHist,'LineWidth',1.5);
    axis square;
    formatFigure('Iteration','');
    set(gca,'LineWidth',1.5);
    legA = legend('New Weights','Old Weights');
    set(legA,'Position',[0.5828 0.3833 0.0938 0.0532]);
    
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
    
    pause;
    if j ~= length(ind2plot)        
       close;
    end
end

%%

clear;