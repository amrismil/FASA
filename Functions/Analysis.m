function [Diseases,Warn,Health,NDVIpoor,NDVIgood,NDVIdead,Threshold]=Analysis(NDVI,SIPI,CIR)
% ANALYSIS
% This function creates a thresholded map of the endangered areas.
%
%   In the resulted threshold, various plants vegetation are color coded.
%   Legion: Red --> dead, Brown --> poor, Yellow --> good, Green --> great.
%
%       Inputs: Vegetation indices (NDVI & SIPI)
%       Outputs: Threshold image and status (diseases & alarms)
%
%See also IMAGE2INDEX, MAPPING.

Threshold = zeros(size(CIR,1),size(CIR,2),3);
r     = zeros(size(CIR,1),size(CIR,2));
g     = zeros(size(CIR,1),size(CIR,2));
b     = zeros(size(CIR,1),size(CIR,2));
% Empty arrays to hold the image values are created.
NDVIdead  = NDVI>=-1&NDVI<=0;
NDVIpoor  = NDVI>0&NDVI<0.33;
NDVIgood  = NDVI>0.33&NDVI<0.66;
NDVIgreat = NDVI>=0.66&NDVI<=1;
% NDVI ranges (-1 to 1) for different vegetation levels.
r(NDVIdead)=208;
g(NDVIdead)=34;
b(NDVIdead)=15;
r(NDVIpoor)=218;
g(NDVIpoor)=181;
b(NDVIpoor)=33;
r(NDVIgood)=253;
g(NDVIgood)=253;
b(NDVIgood)=3;
r(NDVIgreat)=147;
g(NDVIgreat)=191;
b(NDVIgreat)=0;
% Color (RGB) values for the thresholded image. 
Threshold(:,:,1)=r;
Threshold(:,:,2)=g;
Threshold(:,:,3)=b;
%% Alarms
% This code section is for the - must reviewed - alarms and notifications.
Warn=0;
Diseases_low  = SIPI>0 & SIPI<0.8;
Diseases_high = SIPI>1.8 & SIPI<2;
Diseases      = Diseases_low | Diseases_high;
% The diseases map is conducted according to the appropriate SIPI range.
if all(NDVIdead==0,'all') && all(Diseases==0,'all')
    Health=1;
    % There's no dead or diseased plants.
elseif any(NDVIdead~=0,'all')
    Health=2;
    Warn=Warn+1;
    if any(Diseases==1,'all')
        Health=3;
        Warn=Warn+1;
    end
end
end