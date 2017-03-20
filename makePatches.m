function [Mr] = makePatches(imStack,patchSize)

% function to break up an image into many patches of any given size
numRows = size(imStack,1);
numCols = size(imStack,2);
numImgs = size(imStack,3);

idx = 0;
for i = 1:size(imStack,3)
    Im = imStack(:,:,i);
    ii=1:patchSize:numRows;
    [a,b]=ndgrid(ii(1:end-1),ii(1:end-1));
    M=arrayfun(@(x,y) Im(x:x+patchSize-1,y:y+patchSize-1),a,b,'un',0);
    zDim = size(M,1)*size(M,2);
    Mr(:,:,idx+1:idx+zDim) = cell2mat(reshape(M,1,1,size(M,1)*size(M,2)));
    idx = idx +zDim;
    
end
