% This programme can be used to Track multiple faces and Estimating its
% depth by Stereo Imaging

clc;
clear;
close all;

% Load Stereo Parameters Value
load('stereoParams.mat');


% Initialize Camera Objects

camleft = videoinput('winvideo',2);
preview(camleft);
camright = videoinput('winvideo',3);
preview(camright);

pause(5);

figure;

for i = 1:100
   
% take picture from two Camera

I1 = getsnapshot(camleft);
I2 = getsnapshot(camright);

% Undistort the images.
I1 = undistortImage(I1,stereoParams.CameraParameters1);
I2 = undistortImage(I2,stereoParams.CameraParameters2);

% Detecting Faces in images from two Camera

faceDetector = vision.CascadeObjectDetector;
face1 = faceDetector(I1);
face2 = faceDetector(I2);

a = size(face1);
b = size(face2);

% Goto next Loop if no Face detected

if (a(1) == 0 || b(1) == 0)
    continue;
end

center1 = face1(1:2) + face1(3:4)/2;
center2 = face2(1:2) + face2(3:4)/2;

% Estimate position of Point in 3D

point3d = triangulate(center1, center2, stereoParams);
distanceInMeters = norm(point3d)/1000;
distanceAsString = sprintf('%0.2f meters', distanceInMeters);

% Inserting Text and Bouning Box
I1 = insertObjectAnnotation(I1,'rectangle',face1,distanceAsString,'FontSize',18);
I1 = insertShape(I1,'FilledRectangle',face1);


imshow(I1);

pause(.5);
end

closepreview(camleft);
closepreview(camright);

close all;
clc;
clear;