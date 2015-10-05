%decided round 1 code.....let's hope for best
close all;
clc;

%%
V=VideoReader(file);
[m,x1,y1]=VideoBallTrack(V,xb1,yb1,xb2,yb2); %m:slope of traj; x1,y1: position of ball
%%

%detect paddle
frame=read(V,V.NumberOfFrames);
frame=imcrop(frame,[xb1 yb1 xb2-xb1 yb2-yb1]);
gray=rgb2gray(frame);
red=frame(:,:,1)-gray;
red=im2bw(red,graythresh(red));
padstat=regionprops(red);
padstat.BoundingBox(1)=padstat.BoundingBox(1)+xb1;
padstat.BoundingBox(2)=padstat.BoundingBox(2)+yb1;
rectangle('Position',padstat.BoundingBox,'LineWidth',1,'EdgeColor','r'); % show paddle
%%

%predicted position of the ball hitting the paddle
[BallX, BallY,m] = BallPredict( x1,y1,xb1,yb1,xb2,padstat.BoundingBox(2)-16,m);
%%

%detect all blue blocks
blue=frame(:,:,3)-gray;
blue=im2bw(blue,graythresh(blue));
block=regionprops(blue);
cc=bwconncomp(blue);

%choose the lowest block to hit
yMin=block(1).BoundingBox(2);
k=1;
for loop=1:cc.NumObjects
    if (block(loop).BoundingBox(2)<block(k).BoundingBox(2))
        k=loop;
    end
end
block=block(k);
block.BoundingBox(1)=block.BoundingBox(1)+xb1;
block.BoundingBox(2)=block.BoundingBox(2)+yb1;
%%
padRad=((0.5*padstat.BoundingBox(3))^2+(padstat.BoundingBox(4))^2)/(2*padstat.BoundingBox(4));

% padPos=padstat.BoundingBox(1)+padRad;

D=padstat.BoundingBox(2)+padRad;
A=m^2;
B=2*m*BallY-2*m*D-2*BallX*m^2;
C=(padRad)^2*(m^2+1)-(D^2+BallY^2-2*D*BallY)+2*m*BallX*(BallY-D)-BallX^2*m^2;

Ci=((padstat.BoundingBox(2)+padstat.BoundingBox(4)-BallY)/m)+BallX-0.5*padstat.BoundingBox(3);
Cf=(-B+sqrt(B^2+4*A*C))/(2*A);

Ci=Ci+4;
Cf=Cf-4;

if (Ci<xb1+padRad)
    Ci=xb1+padRad;
end

if(Ci<80)
    Ci=80;
end

if (Cf>xb2-padRad)
    Cf=xb2-padRad;
end

if(Cf>720)
    Cf=720;
end

i=1;
sample=0;
padPos=0;

for c=Ci:Cf
    A=1+m;
    B=2*c+2*m*BallX-2*m*BallY+2*m*D;
    C=padRad^2-(c^2+D^2)-m*BallX^2-BallY^2+2*m*BallX*(BallY-D)+2*D*BallY;
    x=(B-sqrt(B^2+4*A*C))/(2*A);
    y=BallY+m*(x-BallX);
    mN=(y-D)/(x-c);
    
    Theta(1) = ang(m); %incident path
    Theta(2)= ang(mN); %Normal
    Theta(3)=(Theta(1)-Theta(2)); %thetaI-thetaN
    Theta(4)=Theta(2)-Theta(3); %reflected path
    m1=tan(180-Theta(4));
    
    xb=x+(1/m1)*(block.BoundingBox(2)+block.BoundingBox(4)-y);
    if (xb>(block.BoundingBox(1)+4) && xb<((block.BoundingBox(1)+block.BoundingBox(3))-4))
        padPos=padPos*sample+c;
        sample=sample+1;
        padPos=padPos/sample;
        rectangle('Position',[xb (block.BoundingBox(2)+block.BoundingBox(4)) 3 3],'LineWidth',1,'EdgeColor','r'); %Estimated Path
        rectangle('Position',[c D 3 3],'LineWidth',1,'EdgeColor','g'); %Estimated Path
    end
end

%deviating path if m1==mN
if(m1==mN)
    if(m1>0)
        padPos=padPos+4;
    elseif(m1<0)
        padPos=padPos-4;
    end
end

% when paddle is not able to make the ball hithit
% if (padPos==0)
%     padPos=(padstat.BoundingBox(2)-BallY)/m+BallX;
% end

%limit boundary conditions based on simulator
if (padPos<80)
    padPos=80;
elseif (padPos>720)
    padPos=720;
end

% Actual Arena
if (padPos<padRad)
    padPos=padRad;
elseif (padPos>800-padRad)
    padPos=800-padRad;
end
    
disp(padPos);
% rectangle('Position',[xb (block.BoundingBox(2)+block.BoundingBox(4)) 3 3],'LineWidth',1,'EdgeColor','r'); %Estimated Path
% disp(i);
rectangle('Position',[padPos D 3 3],'LineWidth',1,'EdgeColor','b'); %Estimated Path
%%

% Display
rectangle('Position',[x1 y1 4 4],'LineWidth',2,'EdgeColor','r'); % Last Visible Ball Position
rectangle('Position',block(k).BoundingBox,'LineWidth',1,'EdgeColor','r'); % Selected Block
rectangle('Position',[BallX BallY 3 3],'LineWidth',1,'EdgeColor','g'); %Estimated Path
%%

%instruct bot to move
driveBot(arduino,padPos,pad);