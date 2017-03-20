function [imStack] = readImages(fileName)
% This function takes in a list of images and returns a 3D stack of images
% 
% fileName is the name of a text files that contains a list of images to
% read
% 
% All images must be that same size. 

fileID = fopen(fileName);
fnames = textscan(fileID,'%s');
fclose(fileID);

fnames = fnames{1};

for i = 1:length(fnames)
    im = imread(fnames{i});
    if ndims(im) > 2
        imStack(:,:,i) = rgb2gray(im);
    else 
        imStack(:,:,i) = im;
    end
end
