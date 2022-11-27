Fully Automated Smart Agriculture (FASA[^note]) system
=========================================

The project mainly aims to assist farmers and business investors in monitoring their agricultural fields to increase crop yields efficiently. It detects areas with water-stressed intervals and subpar vegetation to supply them with water/appropriate nutrients. In this project, a drone captures some CIR images, which then are processed into a Normalized Difference Vegetative Index (NDVI) map; NDVI is a calculated index used to monitor crop health and photosynthetic activity; its use is associated with monitoring and assessing crop vigor across a field, detecting any possible plant diseases. Later on, based on the map, the coordinates of said areas experiencing lack of vegetation are sent to a three-wheeled Omni-directional robot – with a radius of 8 cm, small enough to move across the field – triggering its action: irrigate and spread fertilizers and Super-absorbent Polymers (SAPs), a powder-like material that increases soil moisture, across these areas.

The MATLAB program is a threefold which will enable users to import multispectral images (captured by a drone) for processing. Consequently, view a thresholded NDVI map. In addition, it will prompt land owners to enter the type of plants implanted to determine their appropriate NDVI range. Moreover, it notifies farmers with any persistent alarms.

In conclusion, the primary functions of this MATLAB program are monitoring agricultural lands and making corresponding NDVI maps. Accordingly, a robot will irrigate the areas where water is scarce and spread fertilizers/SAPs upon low vegetation crops.

1. The program consistes of two modes: Automatic and custom.
	- The automatic mode runs the whole program with its default settings including camera specs and plant constant read from "Data.mat" file.
	- The custom mode is made to enable the user to enter all the data available such as said camera specs and plant constant.
2. Camera specs such as sensor hight `sh`, sensor width `sw`, and focal leangth `fl` are used to calculate the GSD resolution.

3. GSD stands for ground sample distance, it means how many meters are represnted in the real life by every pixel in the image; worst case scenario is utilized in GSD due to the fact that Earth is not flat. (I hope you're not a flat-earther.)

4. After entering your options, the program processes the image to an NDVI index that is used to detrmine the areas with good and bad vegetation.

5. The ranges of NDVI is:

		1 < Great vegetation < 0.66
		0.66 < Good vegetation < 0.33
		0.33 < Poor vegetation < 0
		0 < Dead vegetation < -1
6. According to the map, the program determines each area along with its required amounts of water and other nutrients.

7. The output: a colorized thersholded image; a report containing the GSD, the total amount of water, SAPs, and fertilizers needed for the the whole land; any found issues/warnings.

8. Color code for the thresholded image:

		Red: Dead plants or non living things.
		Brown: Poor plant health.
		Yellow: Good plant heath.
		Green: Superior plant health.

## Get Started

### I.	Input function:

```MATLAB
Mode = input('Please choose the FASA mode, Automatic or Custom (A/C): ', 's');
```
There is both automatic and customizable mode in the FASA system; the former would run the whole program depending solely on data files, and the latter is for more modular use as to enter your camera specifications.

```MATLAB
while Band~=1 && Band~=2
	Band = input('Error!! Please choose a valid band mode: 1)RGB-NIR 2)NIR-RGB --> ');
```
This line of code would give the user the choice of which band order is used in the image.

```MATLAB
pc = menu('Choose the type of plant used/wanted:','Asparagus','Sugar beet','Cabbage','Carrot','Corn','Cotton','Cucumber','eggplant','lettuce','oats','onion','pea','potato','soybean','strawberry','sugar cane','tomato','watermelon','wheat','other');
```
This ridiculously long line of code returns the order of your choice to the program and the code will substitute it with the intertwined plant cutoff value according to its type.

### II.	Image2Index function:

```MATLAB
switch Band
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
```
This switch case would assign each band to its appropriate variable according to your previous band order choice in order for the program to run appropriately. So, you must use 4 banded images (multispectral).

```MATLAB
NDVI = (NIR-R)./(NIR+R);
GCI  = (NIR)./(G)-1;
SIPI = (NIR-B)./(NIR-R);
```
Those are the indices furtherly used in the code with their equations dependent on the image bands.

		NDVI: vegetation analysis
		GCI: fertilizers impact
		SIPI: disease indicator

### III.	Analysis function:

```MATLAB
NDVIdead  = NDVI>=-1&NDVI<=0;
NDVIpoor  = NDVI>0&NDVI<0.33;
NDVIgood  = NDVI>0.33&NDVI<0.66;
NDVIgreat = NDVI>=0.66&NDVI<=1;
```
Here, the NDVI is divided to subsequent thresholds according to its vegetation level.

```MATLAB
Threshold(:,:,1)=r;
Threshold(:,:,2)=g;
Threshold(:,:,3)=b;
```
The RGB values are added into one image — the threshold.

```MATLAB
Diseases_low	= SIPI>0 & SIPI<0.8;
Diseases_high	= SIPI>1.8 & SIPI<2;
Diseases	= Diseases_low | Diseases_high;
```
Here, the SIPI values indicating plant diseases are recorded in one variable (Diseases).

### IV.	Mapping function:

```MATLAB
GSD_h = (da*10*sh)/(fl*0.1*size(CIR,1));
GSD_w = (da*10*sw)/(fl*0.1*size(CIR,2));
GSD   = (GSD_h>GSD_w)*GSD_h+(GSD_w>GSD_h)*GSD_w;
```
The worst-case scenario GSD is computed to determine the real to image resolution; this resolution is later used to calculate the coordinates.

```MATLAB
[r_good,c_good]	= find(NDVIgood==1);
[r_poor,c_poor]	= find(NDVIpoor==1);
Coordinates	= [round([r_good,c_good]*GSD,5) ; round([r_poor,c_poor]*GSD,5)];
```
Coordinates of the endangered areas are recorded to one array called “Coordinates.”

### V.	Nutrients:

```MATLAB
Water_needed = round([(1-NDVI(NDVIgood))*pc;(1-NDVI(NDVIpoor))*pc],5);
SAP_amount   = round(Water_needed/301,5);
Fertilizers  = round(Water_needed./(46*Water_needed./((3.82+(max(GCI,[],'all')))-GCI_Fert)),5);
```
In these three lines, the life parameters needed by the plants are given for the recorded values.

### VI.	Output:

```MATLAB
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
        fprintf('\n')
end
```
In this switch case, notifications are presented to the farmers if any dead plants or plant diseases as alarms.

```MATLAB
imwrite(Threshold/255,'Colorized Threshold Map.jpg')
Data = table(Coordinates,Water_needed,SAP_amount,Fertilizers);
writetable(Data,'Coordinates.xlsx')
```
The threshold is made and saved for the farmer's further use and analysis.


## Acknowledgments
	CIE department at the University of Science and Technology at Zewail City
	US Government's free website: [EarthExplorer](https://earthexplorer.usgs.gov/) for aerial imagery


All Rights Reserved to the FASA System team.

This project has been originally published on June 10, 2020.

The objective was to showcase basic functional programming using MATLAB.

[^note]: Yes, the name is a pun that two freshmen came up with whilst working on (what has suddenly became their whole grade) project during the COVID-19 lockdown. We immensely enjoyed it, nonetheless.
