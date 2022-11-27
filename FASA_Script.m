clear
clc
Code="Y";
while Code=="Y" || Code=="y"
[CIR,sh,sw,fl,pc,da,Mode,Band]=Input();
[NDVI,GCI,SIPI]=Image2Index(CIR,Band);
[Diseases,Warn,Health,NDVIpoor,NDVIgood,NDVIdead,Threshold]=Analysis(NDVI,SIPI,CIR);
[GSD,Coordinates]=Mapping(sh,sw,fl,da,NDVIgood,NDVIpoor,CIR);
[Water_needed,SAP_amount,Fertilizers]=Nutrients(NDVI,NDVIgood,NDVIpoor,pc,GCI);
Output(Mode,Band,GSD,pc,NDVIdead,Threshold,Coordinates,Water_needed,SAP_amount,Fertilizers,Health,Warn)
Code=input('Do you want to run FASA again? (Y/N): ', 's');
end