function [xUAV, yUAV] = motionUAV(xUAV, yUAV, xobs, yobs)

v=[0.5 0.5];


% set the new positions
xUAV = v(1) + (xobs-2);
yUAV = v(2) + (yobs+1);