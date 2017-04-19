%%

load('patches.mat');

%%

numBasis = 144;

%%

% imPatches = ((imPatches+1)./2);

%%

for ind = randsample(1:65000,10) % RANDOMLY SAMPLE IMAGE PATCH
    % GRAB IMAGE PATCH
    I = imPatches(:,:,ind);
    % INITIALIZE BASIS FUNCTIONS
    phiInit = 0.05.*(-1+2.*rand([144 numBasis]));
%    phiInit = 0.01.*rand([144 numBasis]);
    % INITIALIZE WEIGHTS
    a = phiInit'*I(:);
    % STD DEV OF IMAGE
    sigma_I = std(I(:));
    % LAMBDA TO SIGMA RATIO
    lambdaSigmaIratio = 0.1;
    % LAMBDA
    lambda = sigma_I.*lambdaSigmaIratio;
    % GET NEW WEIGHTS AND TOTAL ASSOCIATED ERROR
    [aNew,totalError] = minimizeA(I(:),phiInit,a',lambda,sigma_I,200);
    % RECONSTRUCT IMAGE BASED ON OLD WEIGHTS
    reconstructedIold = phiInit*a;
    % RECONSTRUCT IMAGE BASED ON NEW WEIGHTS
    reconstructedI = phiInit*aNew;
    
    figure; 
    set(gcf,'Position',[776 513 1015 820]);
%    subplot(1,3,1);
    subplot(2,2,1);
    plot(totalError,'LineWidth',1.5); axis square;
    formatFigure('Iteration','Cost',['Image number ' num2str(ind)]);
    set(gca,'LineWidth',1.5);   
    
    subplot(2,2,2);
    imagesc(I);
    axis square; colormap gray;
    formatFigure('','','Original image');
    
    subplot(2,2,3);
    imagesc(reshape(reconstructedIold,[12 12]));
    axis square; colormap gray;
    formatFigure('','','Reconstructed image (old weights)');
    
    subplot(2,2,4);
    imagesc(reshape(reconstructedI,[12 12]));
    axis square; colormap gray;
    formatFigure('','','Reconstructed image (new weights)');
    
%     subplot(1,3,2);
%     hist(a,30);
%     axis square;
%     formatFigure('a','Count',['Image number ' num2str(ind)]);
%     set(gca,'LineWidth',1.5);
%     subplot(1,3,3);
%     hist(aNew,30);
%     axis square;
%     formatFigure('a','Count',['Image number ' num2str(ind)]);
%     set(gca,'LineWidth',1.5);
    pause;
    close;
end

%%

clear;