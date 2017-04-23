function phiFinal = sparseCodingAvg(phiInit,allImages)

% INITIALIZE BASIS FUNCTIONS
phi = phiInit;

% RATIO OF LAMBDA TO SIGMA
lambdaSigmaIratio = 0.14;

% FACTOR BY WHICH TO SCALE LEARNING RATE
etaScale = 1;
% ORDER OF IMAGES 
indStore = randsample(1:size(allImages,3),200000,1);

% INITIALIZE MATRICES FOR STORING WEIGHTS AND RESIDUALS
aStore = [];
rStore = [];

for j = 1:length(indStore); % FOR EACH ITERATION
    
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
   eta = etaScale.*1;
   % GET CURRENT IMAGE
   curImage = allImages(:,:,ind);
   % INITIALIZE WEIGHTS IN THIS WAY
   a = rand([1 size(phiInit,2)]);
   % STANDARD DEVIATION OF IMAGE
   sigma_I = std(curImage(:));
   % WEIGHTING OF SPARSENESS RELATIVE TO RECONSTRUCTION ACCURACY
   lambda = sigma_I.*lambdaSigmaIratio;
   % NEW WEIGHTS
   a = minimize1(phi,curImage(:),lambda);
   % STORE NEW WEIGHTS
   aStore(:,end+1) = a;
   % RECONSTRUCT IMAGE USING OLD PHI AND NEW WEIGHT
   reconImg2store = phi*a;
   % SUBTRACT RECONSTRUCTED IMAGE FROM CURRENT IMAGE
   residual = curImage(:)-reconImg2store;
   % STORE RESULTING RESIDUAL
   rStore(:,end+1) = residual;
   
   if mod(j,100) == 0 % EVERY 100 ITERATIONS
       % GET THE MEAN WEIGHT ACROSS THE PREVIOUS 100 ITERATIONS
       a2update = mean(aStore,2);
       % EMPTY THE MATRIX
       aStore = [];
       % GET THE MEAN RESIDUAL ACROSS THE PREVIOUS 100 ITERATIONS
       r2update = mean(rStore,2);
       % EMPTY THE MATRIX
       rStore = [];
       % KEEP OLD PHI FOR L2 FIXING
       phiOld = phi;
       % GET THE NECESSARY CHANGE IN BASIS FUNCTIONS
       deltaPhi = updatePhiAvg(r2update,a2update,eta);
       % ADD CHANGE IN PHI TO GET NEW PHI
       phiNew = phi+deltaPhi;
       % ADAPT L2 NORM OF NEW PHI
       [phiAdapt,~] = fixL2(phiOld,phiNew);
       % NEXT PHI BECOMES CURRENT ADAPTED PHI
       phi = phiAdapt;
   end
   
   if mod(j,1000) == 0
      display(['Iteration ' num2str(j)]);
   end
   
   if mod(j,10000) == 0
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
end

phiFinal = phi;

figure;
set(gcf,'Position',[341 305 1695 1035]);
for i = 1:size(phiFinal,2)
   subplot(12,12,i);
   imagesc(reshape(phiFinal(:,i),[12 12]));
   axis square;
   colormap gray;
   set(gca,'XTick',[]);
   set(gca,'YTick',[]);
end

end