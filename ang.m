function [ theta ] = ang( m )
%ang returns angle wrt baseline taken ACW
%   Detailed explanation goes here
    if ( m>0)
        theta=(1-atan(m)/3.14)*180;
    else
        theta=abs((atan(m)/3.14)*180);
    end
end

