function phiFinal = sparseCoding(phiInit,allImages)

% INITIALIZE BASIS FUNCTIONS
phi = phiInit;

% RATIO OF LAMBDA TO SIGMA
lambdaSigmaIratio = 1.4;

% FACTOR BY WHICH TO SCALE LEARNING RATE
etaScale = 0.2;
% NUMBER OF ITERATIONS
numIter = 1000;
% HOW OFTEN TO PLOT RECONSTRUCTED IMAGE
plotEvery = 4000;
% HOW OFTEN TO TRACK CHANGE IN PHI
trackEvery = 1000;
% SIZE OF BASIS FUNCTION IN 2D
sizeBasis = [12 12];
% ROWS AND COLUMNS FOR PLOTTING BASES
numBasis2plot = [12 12];
% ORDER OF IMAGES 
indStore = randsample(1:size(allImages,3),numIter,1);
indStore = repmat(indStore,[5 1]);
indStore = indStore(:);

% INITIALIZE MATRICES FOR STORING CHANGE IN PHI
trackChanges = [];
trackChangesPreEta = [];

checkCostInd = [9001:9100];
costFuncEg = [];
sparseEg = [];

for j = 1:length(indStore);
   % SET ETA DEPENDING ON ITERATION
   if j < 600
      eta = 5;
   elseif j < 1200
      eta = 2.5;
   else
      eta = 1; 
   end
   % CURRENT IMAGE
   ind = indStore(j);
   % SCALE ETA APPROPRIATELY
   eta = etaScale.*eta;
   % GET CURRENT IMAGE
   curImage = allImages(:,:,ind);
   % INITIALIZE WEIGHTS IN THIS WAY
%   a = rand([1 size(phiInit,2)]);
   % STANDARD DEVIATION OF IMAGE
   sigma_I = std(curImage(:));
   % WEIGHTING OF SPARSENESS RELATIVE TO RECONSTRUCTION ACCURACY
   lambda = sigma_I.*lambdaSigmaIratio;
   % NEW WEIGHTS
   a = minimize1(phi,curImage(:),lambda);
   % KEEP OLD PHI FOR L2 FIXING
   phiOld = phi;
   % GET THE NECESSARY CHANGE IN BASIS FUNCTIONS
   [deltaPhi,deltaPhiPreEta] = updatePhi(curImage(:),phi,a',eta);
   % ADD CHANGE IN PHI TO GET NEW PHI
   phiNew = phi+deltaPhi;
   if mod(j,trackEvery) == 0
       % TRACK MAGNITUDE OF PHI UPDATES
       trackChanges(end+1) = mean(abs(deltaPhi(:)));
       trackChangesPreEta(end+1) = mean(abs(deltaPhiPreEta(:)));
   end
   % ADAPT L2 NORM OF NEW PHI
   [phiAdapt,~] = fixL2(phiOld,phiNew);
   % NEXT PHI BECOMES CURRENT ADAPTED PHI
   phi = phiAdapt;
   
   if mod(j,1000) == 0
      display(['Iteration ' num2str(j)]);
   end
   
   if mod(j,plotEvery) == 0
      figure;
      set(gcf,'Position',[582 715 1136 420]);
      subplot(1,2,1);
      imagesc(curImage);
      axis square; colormap gray;
      formatFigure('','','Original');
      set(gca,'XTick',[]);
      set(gca,'YTick',[]);
      
      reconImg = phiOld*a;
      
      subplot(1,2,2);
      imagesc(reshape(reconImg,[12 12]));
      axis square; colormap gray;
      formatFigure('','','Reconstructed');
      set(gca,'XTick',[]);
      set(gca,'YTick',[]);
   end
   
   if sum(checkCostInd==j)>0
      costFuncEg(end+1) = sum((curImage(:) - phi*a).^2) + lambda.*sum(log(1+a.^2)./log(2));
      sparseEg(end+1) = sum(log(1+a.^2)./log(2));
   end
end

phiFinal = phi;

figure;
set(gcf,'Position',[341 305 1695 1035]);
for i = 1:size(phiFinal,2)
   subplot(numBasis2plot(1),numBasis2plot(1),i);
   imagesc(reshape(phiFinal(:,i),sizeBasis));
   axis square;
   colormap gray;
   set(gca,'XTick',[]);
   set(gca,'YTick',[]);
   caxis(minmax(phiFinal));
end

figure;
plot(trackChanges,'LineWidth',1.5);
axis square;
formatFigure('Iteration','Update magnitude');
set(gca,'LineWidth',1.5);

figure;
plot(trackChangesPreEta,'LineWidth',1.5);
axis square;
formatFigure('Iteration','Update magnitude');
set(gca,'LineWidth',1.5);

end