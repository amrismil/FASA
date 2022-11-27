function [GSD,Coordinates]=Mapping(sh,sw,fl,da,NDVIgood,NDVIpoor,CIR)
% MAPPING
% This function maps the land using GSD.
%
%   GSD is the area of actual ground occupied by the center two pixels.
%   The used GSD is the worst case scenario as the ground is not flat.
%   The coordinates of the resolutioned stressed areas are recorded.
%
%       Inputs: Camera specs
%       Outputs: Endangered plants map and GSD (resolution)
%
%See also ANALYSIS, NUTRIENTS.

GSD_h = (da*10*sh)/(fl*0.1*size(CIR,1));
GSD_w = (da*10*sw)/(fl*0.1*size(CIR,2));
GSD   = (GSD_h>GSD_w)*GSD_h+(GSD_w>GSD_h)*GSD_w;
[r_good,c_good] = find(NDVIgood==1);
[r_poor,c_poor] = find(NDVIpoor==1);
Coordinates = [round([r_good,c_good]*GSD,5);round([r_poor,c_poor]*GSD,5)];
end