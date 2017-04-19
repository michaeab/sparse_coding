function phiFinal = sparseCoding(phiInit,allImages)

% INITIALIZE BASIS FUNCTIONS
phi = phiInit;

% RATIO OF LAMBDA TO SIGMA
lambdaSigmaIratio = 0.1;

% NUMBER OF ITERATIONS PER WEIGHT
numIter = 10;

% ALPHA TERM IN L2 NORMALIZING
alpha = 0.01;

% RUNNING SUM OF A
runSum = zeros([1 size(phiInit,2)]);
% runSum = [];

phiAdaptL2 = [];

scaleFactorStore = [];

etaScale = 0.1;

aInitStore = [];

aStore = [];

for ind = 1:size(allImages,3)
   if ind<600
      eta = etaScale*5; 
   elseif ind<1200
      eta = etaScale*2.5; 
   else
      eta = etaScale*1; 
   end
   % GET CURRENT IMAGE
   curImage = allImages(:,:,ind);
   % INITIALIZE WEIGHTS IN THIS WAY
   a = phi'*curImage(:);
%   aInitStore(ind,:) = a;
   % STANDARD DEVIATION OF IMAGE
   sigma_I = std(curImage(:));
   % WEIGHTING OF SPARSENESS RELATIVE TO RECONSTRUCTION ACCURACY
   lambda = sigma_I.*lambdaSigmaIratio;
   % NEW WEIGHTS
   a = minimizeA(curImage(:),phi,a',lambda,sigma_I,numIter);
   % ADD NEW WEIGHTS TO RUNNING SUM
   runSum = runSum+a';
%   runSum(:,ind) = a;
   phiOld = phi;
   % GET THE NECESSARY CHANGE IN BASIS FUNCTIONS
   deltaPhi = updatePhi(curImage(:),phi,a',eta);
   % ADD CHANGE IN PHI TO GET NEW PHI
   phiNew = phi+deltaPhi;
   % ADAPT L2 NORM OF NEW PHI
%   [phiAdapt, scaleFactor] = adaptL2(phiNew,sigma_I,alpha,(runSum.^2)./ind);
   [phiAdapt,scaleFactor] = fixL2(phiOld,phiNew);
%   scaleFactorStore(ind,:) = scaleFactor;
%   phiAdaptL2(ind,:) = sqrt(sum(phiAdapt.^2));
   % NEXT PHI BECOMES CURRENT ADAPTED PHI
%   aStore(ind,:) = a; 
   phi = phiAdapt;
   if mod(ind,1000) == 0
      display(['Iteration ' num2str(ind)]);
   end
   if mod(ind,10000) == 0
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

% [valsAfter, binsAfter] = hist(aStore(:),100);
% [valsBefore, binsBefore] = hist(aInitStore(:),100);
% figure; plot(binsBefore,valsBefore./length(aStore(:))); axis square
% hold on;
% plot(binsAfter,valsAfter./length(aStore(:)));
% set(gca,'Yscale','log')

end