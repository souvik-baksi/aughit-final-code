file='a.avi';

%initialize video frame
[ xb1,yb1,xb2,yb2 ] = Ybound(file);
[ xb1,yb1,xb2,yb2 ] = CenterBound( xb1,yb1,xb2,yb2 );