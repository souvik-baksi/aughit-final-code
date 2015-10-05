function [ xb1,yb1,xb2,yb2 ] = CenterBound( xb1,yb1,xb2,yb2 )
%CENTERBOUND Draws the boundary with centroid
%   [ xb1,yb1,xb2,yb2 ] = CenterBound( xb1,yb1,xb2,yb2 );
    
    r=16;
    xb1=xb1+r;
    yb1=yb1+r;
    xb2=xb2-r;
    yb2=yb2-r;
end

