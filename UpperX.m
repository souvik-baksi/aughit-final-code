function x = UpperX( )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

    vid = videoinput('winvideo', 2, 'MJPG_1024x576'); %sample device format
%     vid = videoinput('winvideo', 1, 'YUY2_640x480'); %sample device format
    vid.FramesPerTrigger = 1;
    vid.ReturnedColorspace='RGB';
    preview(vid);
    
    for i=1:7
        img=getsnapshot(vid);
    end
    
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
    x=prop(k).BoundingBox(1)+prop(k).BoundingBox(3);
    rectangle('Position',[x 0 1 600],'LineWidth',1,'EdgeColor','r');
    
end

