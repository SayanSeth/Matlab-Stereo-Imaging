% This programme is Capture Images from two Cameras Simultaneously and
% Save it to a particular location
% It is useful for stereo camera callibration app

clc;
clear;
close all;

cam = webcamlist;
camleft = videoinput('winvideo',3);
preview(camleft);
camright = videoinput('winvideo',2);
preview(camright);

pause(10);

savepath1 = 'C:\Users\sssay\Documents\MATLAB\Stereo Camera Left';  %the folder
savepath2 = 'C:\Users\sssay\Documents\MATLAB\Stereo Camera Right';  %the folder

nametemplate = 'image_%04d.png';  %name pattern

imnum = 0;        %starting image number
for i = 1 : 20    %if you want to do this 50 times
   im1 = getsnapshot(camleft);
   im2 = getsnapshot(camright);
   
   h = msgbox('Operation Completed','Success');
   
   imnum = imnum + 1;
   
   file1 = sprintf(nametemplate, imnum);  %create filename
   fullname1 = fullfile(savepath1, file1);  %folder and all
   imwrite( im1, fullname1);  %write the image there as png
   
   file2 = sprintf(nametemplate, imnum);  %create filename
   fullname2 = fullfile(savepath2, file2);  %folder and all
   imwrite( im2, fullname2);  %write the image there as png
   
   pause(5);
end


closepreview(camleft);
closepreview(camright);

clc;
clear;
close all;