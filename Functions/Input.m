function [CIR,sh,sw,fl,pc,da,Mode,Band]=Input()
% INPUT gathers all users' modular inputs for further use.
%
%   Do not add inputs argument for this function such as [x,y,z]=Input().
%
%See also uigetfile, imread, imresize, load, menu.

Mode = input('Please choose the FASA mode, Automatic or Custom (A/C): ', 's');
% A refers to the automatic code where data is taken from data files.
% C indicates the customisable code where users enter data.
while Mode~="A" && Mode~="C" && Mode~="a" && Mode~="c"
    Mode = input('Error!! Please choose a valid FASA mode, Automatic or Custom (A/C): ', 's');
end
Band = input('Please choose the band mode: 1)RGB-NIR 2)NIR-RGB --> ');
% Users choose the correct order of image channels/bands to be uploaded.
while Band~=1 && Band~=2
    Band = input('Error!! Please choose a valid band mode: 1)RGB-NIR 2)NIR-RGB --> ');
end
url = 'https://earthexplorer.usgs.gov/';
msg = "You can download a four band NAIP image from the US Government's free website here.";
fprintf('<a href = "%s">%s</a>\n',url,msg)
% This websites enables users to download NAIP images for CIR usage.
% It is free and only requires registration.
pause(3);
[name,path] = uigetfile('*.tif',"Agricultural land image upload");
CIR         = imread([path,name]);
resize      = ((size(CIR,1)*size(CIR,2)<=801608)*1)+((size(CIR,1)*size(CIR,2)>801608&&size(CIR,1)*size(CIR,2)<4953600)*0.5)+((size(CIR,1)*size(CIR,2)>=4953600)*0.1);
CIR         = imresize(CIR, resize);
% Image.tif being uploaded gets resized for easy and faster computations.
%% FASA mode
% This code section is to input all the data according to the choosen mode.
if Mode=="A" || Mode=="a"
    Data = load('Data.mat','-ascii');
    sh  = Data(1);
    sw  = Data(2);
    fl  = Data(3);
    pc  = Data(4);
    da  = Data(5);
    % Data is uploaded from said file for the camera specs.
elseif Mode=="C" || Mode=="c"
    sh  = input("Enter camera Sensor hight (mm): ");
    sw  = input("Enter camera Sensor width (mm): ");
    fl  = input("Enter camera Sensor focal leangth (mm): ");
    da  = input("Enter drone alltitude (m): ");
    pc = menu('Choose the type of plant used/wanted:','Asparagus','Sugar beet','Cabbage','Carrot','Corn','Cotton','Cucumber','eggplant','lettuce','oats','onion','pea','potato','soybean','strawberry','sugar cane','tomato','watermelon','wheat','other');
    if pc == 20
        pc = input("Enter plant cutoff value: ");
        % If users wish, they are able to enter their plant cutoff.
        % Plant cutoff must be calculated correctly, about range: 0-2.
    else
        choice = load('Plant_type.mat','-ascii');
        pc     = choice(pc); 
    end
end
end