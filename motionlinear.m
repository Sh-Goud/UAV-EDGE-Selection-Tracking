function [xobs, yobs]= motionlinear(xobs, yobs)
% is v supposed to be an array of velocities?
v=[0.5 0.5];
x1 = xobs;
y1 = yobs;
% I chose this angle (not sure why you were using an array of values?)
% if x1 < 15
%     theta=pi/4;
% end
% 
% if x1>=15 && y1<=30
%     theta=pi/2;
% end
% 
% if x1>=15 && y1>=30
%     theta=0;
% end
% 
% if x1>=15 && y1>=25
%     theta=0;
% end
% 
% if x1>=25
%     theta=-pi/2;
% end
% 
% if x1>=25 && y1<=20
%     theta=0;
% end
% 
% if x1>=35 
%     theta=pi/2;
% end
% 
% if x1>=35 && y1<=25
%     theta=pi/4;
% end
%     
%**************************************
% if x1 < 25
%     theta=pi/4;
% end
% 
% if x1>=25 && y1<=30
%     theta=pi/2;
% end
% 
% if x1>=15 && y1>=30
%     theta=0;
% end

theta=pi/4;

% set the new positions
xobs = v(1)*cos(theta) + xobs;
yobs = v(2)*sin(theta) + yobs;