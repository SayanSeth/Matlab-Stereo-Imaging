% This program can track an yellow color obect and estimate its depth


close all;
clear;
clc;

% Initialize Camera Objects

vid_left = videoinput('winvideo',3);
vid_right = videoinput('winvideo',2);

preview(vid_left);

pause(5);

% Load Stereo Parameters Value

load('stereoParams.mat');

for i = 1:20
    
    % take picture from two Camera
    
    I1 = getsnapshot(vid_left);
    I2 = getsnapshot(vid_right);
    
    % Remove Distortion Due to Camera
    
    I1 = undistortImage(I1,stereoParams.CameraParameters1);
    I2 = undistortImage(I2,stereoParams.CameraParameters2);
    
    % Binarizing in Left Image
    
    R = I1(:,:,1); G = I1(:,:,2); B = I1(:,:,3);
    
    out1 = R > 130 & G > 130 & B < 50;  % Change the value
    bw1 = bwmorph(out1,'dilate',1);
    stats1 = regionprops(bw1,'BoundingBox','Centroid','Area');
    
    % Binarizing in Right Image
    
    R = I2(:,:,1); G = I2(:,:,2); B = I2(:,:,3);    
    
    out2 = R > 110 & G > 110 & B < 40;  % Change the value
    bw2 = bwmorph(out2,'dilate',1);
    stats2 = regionprops(bw2,'BoundingBox','Centroid','Area');
     
     n1 = length(stats1);
     ba1 = zeros(1,n1);
     
     n2 = length(stats2);
     ba2 = zeros(1,n2);
     % Goto next Loop if no object detected
     
     if n1 == 0 || n2 == 0
         continue
     end
     
     % Comapring the Areas of Dtected object in Left Frame
     for object=1:n1
         ba1(1,object)=stats1(object).Area;
     end
    
         [k,m] = max(ba1);
    
         bb1=stats1(m).BoundingBox;
         bc1=stats1(m).Centroid;
      % Comapring the Areas of Dtected object in Left Frame
      
      for object=1:n2
         ba2(1,object)=stats2(object).Area;
     end
    
         [k,m] = max(ba2);
    
         bb2=stats2(m).BoundingBox;
         bc2=stats2(m).Centroid;
      
      % Estimate position of Point in 3D
      
      point3d = triangulate(bc1, bc2, stereoParams);
      distanceInMeters = norm(point3d)/1000;
      
      % Inserting Text and Bouning Box
      
    text = ['X:',num2str(bc1(1)) '  Y:' num2str(bc1(2)) ' Depth:' num2str(distanceInMeters)];
    position = bc1;
    box_color = 'black';
    
    I1 = insertText(I1,position,text,'FontSize',18,'BoxColor',box_color,'BoxOpacity',1,'TextColor','white');
    imshow(I1);
    hold on
    rectangle('Position',bb1,'EdgeColor','Y','LineWidth',2);
    plot(bc1(1),bc1(2),'-r+');
    hold off;
    
    % pause
    
    pause(.1);
end
    closepreview(vid_left);
    clc;
    clear;
    close all;
    
    
    
    
    
   