function [x2,y2,m] = BallPredict( x1,y1,xb1,yb1,xb2,yb2,m)
%predicts all ball position at xb1,xb2,yb1 and yb2
%   x = BallPredict(x1,y1,xb1,yb1,xb2,yb2,m) present position at x1,y1 transfered to x,y
    y=y1;
    x=x1;
    while (y<yb2)
        x2=x;
        y2=y;
        if (x<=xb1 || x>=xb2)
            m=m*(-1);
            if (x<=xb1 && m>0) % hits first x boundary
                y=yb2;
            elseif  (x>=xb2 && m<0) % hits second x boundary
                    y=yb2;
            end
            x=x1+(y-y1)/m;
            
        else if (m>0)%  continues any where from the middle of space
                x=xb2;
            else
                x=xb1;
            end
            y=y1+m*(x-x1);
            
            if (y>=yb2)
                y=yb2;
                x=x1+(y-y1)/m;
            end
        end
        x1=x;
        y1=y;

        %projected ball position
        rectangle('Position',[x y 2 2],'LineWidth',2,'EdgeColor','r');
    end
end

