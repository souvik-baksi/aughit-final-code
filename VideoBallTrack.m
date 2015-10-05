function [m,x,y] = VideoBallTrack( obj,xb1,yb1,xb2,yb2 )
%Tracks the ball in from the video , locates it on a cordinate map, return
%the slope of the final path and final postion
%   [slope,x_final,y_final]= VideoBallTrack(VideoObject,x_boundary1,y_boundary1,x_boundary2,y_boundary2);
    thresh=0;    
    x=-1;
    x1=-1;
    x2=-1;
    y=-1;
    y1=-1;
    y2=-1;
    m=0;
    sample=0;
    f=0;
    nFrames=obj.NumberOfFrames;
    

    for k=1:nFrames
        img=read(obj,k);
        
        if (k==1)
            imshow(img);title('Game View (full)');
            rectangle('Position',[xb1 yb1 xb2-xb1 yb2-yb1],'LineWidth',1,'EdgeColor','g');
        end

        
        %yellow block detect
        J=imcrop(img,[xb1 yb1 (xb2-xb1) (yb2-yb1)]);
        J(:,:,3)=0*J(:,:,3);%removes blue colour from image
%         bw1=im2bw(J);%binarize the image
        gray=rgb2gray(J);%find the grayscale image
        
        %binarized green and red layer, remove common portion both in red
        %and green layer
        red=J(:,:,1);
        green=J(:,:,2)-gray;
        red=im2bw(red,graythresh(red));
        green=im2bw(green,graythresh(green));
        green=green-red;
        green=im2bw(green);
        
%         figure(),imshow(green); title('ball detect only');


        try
            %ball detect
            prop=regionprops(green);
            maxArea=prop(1).Area;
            cc=bwconncomp(green);
            k=1;
            for loop=1:cc.NumObjects
                if (prop(loop).Area>maxArea)
                    maxArea=prop(loop).Area;
                    k=loop;
                end
            end
            prop(k).BoundingBox(1)=prop(k).BoundingBox(1)+xb1;
            prop(k).BoundingBox(2)=prop(k).BoundingBox(2)+yb1;
%             rectangle('Position',prop(k).BoundingBox,'LineWidth',1,'EdgeColor','r');
            x=prop(k).Centroid(1)+xb1;
            y=prop(k).Centroid(2)+yb1;
            rectangle('Position',[x y 1 1],'LineWidth',1,'EdgeColor','g');

            
            if (((y1>y && y2<y1) || (y1<y && y2>y1) || (x1>x && x2<x1) || ...
                    (x1<x && x2>x1)) && ~((y1==-1) || (x1==-1) ||(y2==-1)...
                    ||(x2==-1) ||(y==-1) || (x==-1)))
                
                if (y1>y && y2<y1) % bounced at yb2
                    f=0;
                    y0=y;
                    x0=x;
                    m=0;
                    sample=0;
                end

                if (y1<y && y2>y1) % bounced at yb1
                    f=0;
                    y0=y;
                    x0=x;
                    m=0;
                    sample=0;
                end

                if (x1>x && x2<x1) % bounced at xb2
                    f=0;
                    y0=y;
                    x0=x;
                    m=0;
                    sample=0;
                end

                if (x1<x && x2>x1) % bounced at xb1
                    f=0;
                    y0=y;
                    x0=x;
                    m=0;
                    sample=0;
                end
            end

            %Slope Determination
            if (f==1)
                m=m*sample + ((y-y0)/(x-x0));
                sample=sample+1;
                m=m/sample;
            end
            f=1;
            x2=x1;
            y2=y1;
            x1=x;
            y1=y;
            y0=y;
            x0=x;
        end 
    end
end
