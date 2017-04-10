%% Master Script for sparse coding 

%% Read Images
fileName = 'street.txt';
[imStack] = readImages(fileName);

%% Blur Here ???

%% Break into patches
patchSize = 16; 
[imPatches] = makePatches(imStack,patchSize);

%% Sparse Coding

%% Profit

