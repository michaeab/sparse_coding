%%

load('patches.mat');

%%

for ind = randsample(1:65000,10) % RANDOMLY SAMPLE IMAGE PATCH
    % GRAB IMAGE PATCH
    I = imPatches(:,:,ind);
    % INITIALIZE BASIS FUNCTIONS
    phiInit = 0.05.*(-1+2.*rand([144 192]));
    % INITIALIZE WEIGHTS
    a = phiInit'*I(:);
    % STD DEV OF IMAGE
    sigma_I = std(I(:));
    % LAMBDA TO SIGMA RATIO
    lambdaSigmaIratio = 0.1;
    % LAMBDA
    lambda = sigma_I.*lambdaSigmaIratio;
    % GET NEW WEIGHTS AND TOTAL ASSOCIATED ERROR
    [aNew,totalError] = minimizeA(I(:),phiInit,a',lambda,sigma_I,20);
    reconstructedI = phiInit*aNew;
    figure; 
    set(gcf,'Position',[515 662 1285 420]);
%    subplot(1,3,1);
    subplot(1,3,1);
    plot(totalError,'LineWidth',1.5); axis square;
    formatFigure('Iteration','Cost',['Image number ' num2str(ind)]);
    set(gca,'LineWidth',1.5);
    subplot(1,3,2);
    imagesc(I);
    axis square; colormap gray;
    subplot(1,3,3);
    imagesc(reshape(reconstructedI,[12 12]));
    axis square; colormap gray;
    
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