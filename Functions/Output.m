function Output(Mode,Band,GSD,pc,~,Threshold,Coordinates,Water_needed,SAP_amount,Fertilizers,Health,Warn)
% OUTPUT prints out all data either in command window or files.
%
%   Do not add output argument for this function such as []=Output(x,y,z).
%
%See also switch, imshow, imwrite, writetable, fopen.

if Mode=='C' || Mode=='c'
%% Switch Cases
% This code section is used to determine the final images output.
    switch Band
        case 1
            disp('<a href="matlab: imshow(CIR(:,:,1:3)); ">Original Image</a>')
        case 2
            disp('<a href="matlab: imshow(CIR(:,:,2:4)); ">Original Image</a>')
            % Show the original RGB image according to the Band order.
    end
    switch Health
        case 1
            disp("Congrats!! your plant is in a good health.")
            disp("Hooray! Zero Warnings.")
        otherwise
            fprintf("%d warnings\n",Warn)
            disp('<a href="matlab: imshow(~NDVIdead); ">Warning: Click here for showing dead areas</a>')
            if Health == 3
                disp('<a href="matlab: imshow(~Diseases); ">Warning: Click here for showing places with disease</a>')
            end
            % Show the Diseases and Dead areas in black (1 values).
            fprintf('\n')
    end
%% Products
% This code section prints the formated desired output: Threshold & GSD.
    disp('<a href="matlab: imshow(Threshold/255); ">Colorized Threshold Map</a>')
    fprintf("Legion: Red is dead/not plants, Brown is poor vegetation, Yellow is good crops, Green is great yeild.\n")
    if GSD>100
        GSD=GSD/100;
        fprintf("GSD: %f m/px\n",GSD)
    else
        fprintf("GSD: %f cm/px\n",GSD)
    end
end
%% Files
% This code section saves all the produced data into files.
imwrite(Threshold/255,'Colorized Threshold Map.jpg')
Data = table(Coordinates,Water_needed,SAP_amount,Fertilizers);
writetable(Data,'Coordinates.xlsx')
% Coordinates parameters are recorded in an excel sheet for the robot.
fileID = fopen('Report.txt','w');
if GSD>100
    GSD=GSD/100;
    fprintf(fileID,'GSD: %f m/px\n',GSD);
else
    fprintf(fileID,'GSD: %f cm/px\n',GSD);
end
fprintf(fileID,'Total amount of water needed is about %d liters.\n',fix(sum(Water_needed,'all')));
fprintf(fileID,'Total amount of SAPs wanted is about %d grams.\n',fix(sum(SAP_amount,'all')));
fprintf(fileID,'Total amount of Fertilizers recommended is about %d grams.\n',fix(sum(Fertilizers,'all')));
fprintf(fileID,'The soil will hold to about %d liters of waters through out %d days.\n',fix(sum(Water_needed,'all')/50),ceil(pc*21));
switch Health
    case 1
        fprintf(fileID,'Congrats!! your plant is in a good health.\n');
        fprintf(fileID,'Hooray! Zero Warnings.\n');
    otherwise
        fprintf(fileID,"There's %d warnings, check alarms.\n",Warn);
end
fclose(fileID);
% Construct a report of crucial details for the user.
end