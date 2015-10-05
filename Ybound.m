function [xb1,yb1,xb2,yb2]=Ybound(file)

I=VideoReader(file);
I=read(I,1);
%imshow(I);
I(:,:,3)=0*I(:,:,3);%removes blue colour from image
bw1=im2bw(I);
gray=rgb2gray(I); 

red=im2bw(I(:,:,1)-gray); % threshold sensitive
bw1=bw1-red;

% transform inbound red and green layer to yellow
I(:,:,1)=I(:,:,1)+I(:,:,2);
I(:,:,2)=I(:,:,1);

bw2=im2bw(I);
bw2=imfill(bw2,'holes');
J=im2bw(bw2-bw1);
J=imfill(J,'holes'); %fill green hole
%imshow(J);
stat=(regionprops(J));
%rectangle('Position',stat.BoundingBox,'LineWidth',2,'EdgeColor','r');
xb1=stat.BoundingBox(1);
yb1=stat.BoundingBox(2);
xb2=stat.BoundingBox(1)+stat.BoundingBox(3);
yb2=stat.BoundingBox(2)+stat.BoundingBox(4);
end

