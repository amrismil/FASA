function [NDVI,GCI,SIPI]=Image2Index(CIR,Band)
% IMAGE2INDEX
% This function convert images to various types of indices.
%
%   Normalized Difference Vegetation Index (NDVI) is for vegetation analysis.
%   Green Chlorophyll Index (GCI) is monitoring fertilizers impact on leafs.
%   Structure Insensitive Pigment Index (SIPI) is a plant disease indicator.
%
%       Inputs: CIR image (4 bands)
%       Outputs: Vegetation indices (NDVI, GCI, SIPI)
%
%See also ANALYSIS, MAPPING.

switch Band
    % According to users choice, the program will deal with image bands.
    case 1
        R   = double(CIR(:,:,1));
        G   = double(CIR(:,:,2));
        B   = double(CIR(:,:,3));
        NIR = double(CIR(:,:,4));
    case 2
        NIR = double(CIR(:,:,1));
        R   = double(CIR(:,:,2));
        G   = double(CIR(:,:,3));
        B   = double(CIR(:,:,4));
end
NDVI = (NIR-R)./(NIR+R);
GCI  = (NIR)./(G)-1;
SIPI = (NIR-B)./(NIR-R);
end