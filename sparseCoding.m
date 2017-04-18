function phiFinal = sparseCoding(phiInit,allImages)

% INITIALIZE BASIS FUNCTIONS
phi = phiInit;

% RATIO OF LAMBDA TO SIGMA
lambdaSigmaIratio = 0.1;

% NUMBER OF ITERATIONS PER WEIGHT
numIter = 20;

% ALPHA TERM IN L2 NORMALIZING
alpha = 0.01;

% RUNNING SUM OF A
runSum = zeros([1 size(phiInit,2)]);

phiAdaptL2 = [];

for ind = 1:1 % size(allImages,3)
   if ind<600
      eta = 5; 
   elseif ind<1200
      eta = 2.5; 
   else
      eta = 1; 
   end
   % GET CURRENT IMAGE
   curImage = allImages(:,:,ind);
   % INITIALIZE WEIGHTS IN THIS WAY
   a = phi'*curImage(:);
   % STANDARD DEVIATION OF IMAGE
   sigma_I = std(curImage(:));
   % WEIGHTING OF SPARSENESS RELATIVE TO RECONSTRUCTION ACCURACY
   lambda = sigma_I.*lambdaSigmaIratio;
   % NEW WEIGHTS
   a = minimizeA(curImage(:),phi,a',lambda,sigma_I,numIter);
   % ADD NEW WEIGHTS TO RUNNING SUM
   runSum = runSum+a';
   % GET THE NECESSARY CHANGE IN BASIS FUNCTIONS
   deltaPhi = updatePhi(curImage(:),phi,a',eta);
   % ADD CHANGE IN PHI TO GET NEW PHI
   phiNew = phi+deltaPhi;
   % ADAPT L2 NORM OF NEW PHI
   [phiAdapt, scaleFactor] = adaptL2(phiNew,sigma_I,alpha,(runSum.^2)./ind);
   phiAdaptL2(ind,:) = sqrt(sum(phiAdapt.^2));
   % NEXT PHI BECOMES CURRENT ADAPTED PHI
   phi = phiAdapt;
   if mod(ind,100) == 0
      display(['Iteration ' num2str(ind)]);
   end
end

phiFinal = phi;

end