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

for ind = 1:2000 % size(allImages,3)
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
   aNew = minimizeA(curImage(:),phi,a',lambda,sigma_I,numIter);
   % ADD NEW WEIGHTS TO RUNNING SUM
   runSum = runSum+aNew';
   % GET THE NECESSARY CHANGE IN BASIS FUNCTIONS
   deltaPhi = updatePhi(curImage(:),phi,aNew',eta);
   % STORE THE CURRENT PHI AS 'OLD' PHI
   phiOld = phi;
   % ADD CHANGE IN PHI TO GET NEW PHI
   phiNew = phi+deltaPhi./100000;
   % ADAPT L2 NORM OF NEW PHI
   phiAdapt = adaptL2(phiNew,phiOld,sigma_I,alpha,runSum./ind);
   % NEXT PHI BECOMES CURRENT ADAPTED PHI
   phi = phiAdapt;
   if mod(ind,100) == 0
      display(['Iteration ' num2str(ind)]);
   end
end

phiFinal = phi;

end