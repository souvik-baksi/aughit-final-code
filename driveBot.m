function []=driveBot(arduino,padPos,limit)
%Bot Control: AugHit, Robotix 2015
%driveBot(arduino,padPos);

f=1;

%webcam image to be scaled to 800x600
% scale=1.2;
scale=(limit(2)-limit(1))/800;

padPos=padPos*scale;

vid = videoinput('winvideo', 2, 'MJPG_1024x576'); %arena webcam
% vid = videoinput('winvideo', 1, 'YUY2_640x480'); %self device format
vid.FramesPerTrigger = 1;
vid.ReturnedColorspace='RGB';
preview(vid);

while(f)
    for i=1:7
        img=getsnapshot(vid);
    end
    img=imcrop(img,[limit(1) 0 limit(2)-limit(1) 450]);
%     imshow(img);
    red=img(:,:,1);
    gray=rgb2gray(img);
    red=red-gray;
    red=im2bw(red,graythresh(red));
    red=imfill(red,'holes');
    prop=regionprops(red,'Centroid','BoundingBox','Area');
    maxArea=prop(1).Area;
    cc=bwconncomp(red);
    k=1;
    for loop=1:cc.NumObjects
        if (prop(loop).Area>maxArea)
            maxArea=prop(loop).Area;
            k=loop;
        end
    end
    imshow(red);
    rectangle('Position',prop(k).BoundingBox,'LineWidth',1,'EdgeColor','r');
    data='';
    
    if (padPos<0.5*prop(k).BoundingBox(3))
        padPos=0.5*prop(k).BoundingBox(3);
    elseif (padPos>800-0.5*prop(k).BoundingBox(3))
        padPos=800-0.5*prop(k).BoundingBox(3);
    end
    
    %optimisation needed
    if (padPos-prop(k).Centroid(1)>5)
        data=8;
    elseif (padPos-prop(k).Centroid(1)<-5)
        data=2;
    else
        f=0;
        data=0;
    end
    
    disp(prop(k).Centroid(1));
    disp(data);
    fprintf(arduino,'%d',data);
%     pause(1);
end
end