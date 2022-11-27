function [Water_needed,SAP_amount,Fertilizers]=Nutrients(NDVI,NDVIgood,NDVIpoor,pc,GCI)
% NUTRIENTS
% This function calculates SAPs, water, and fertilizers amount.
%
%   The three said parameters are sent for the robot to apply.
%   The three-wheeled omnidirectional robot would head for the coordinates.
%
%       Inputs: Plants type and GCI
%       Outputs: Water and SAPs needed in areas with vegetation deficiency
%
%See also MAPPING, ANALYSIS.

Water_needed = round([(1-NDVI(NDVIgood))*pc;(1-NDVI(NDVIpoor))*pc],5);
SAP_amount   = round(Water_needed/301,5);
GCI_Fert     = [GCI(NDVIgood);GCI(NDVIpoor)];
% The GCI values for the poor and good vegetation levels.
Fertilizers  = round(Water_needed./(46*Water_needed./((3.82+(max(GCI,[],'all')))-GCI_Fert)),5);
end