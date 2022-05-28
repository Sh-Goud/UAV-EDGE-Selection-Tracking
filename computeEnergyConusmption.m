function Econsump = computeEnergyConusmption(beta, strategy)

%The range of operands required by the task is 500–2000 megacycle
%the CPU cycle of UAV is 0.1–1 GHz, and the clock frequency of the edge node  is 10 GHz.

k = 10e-8; %energy efficiency parameter that is mainly depends on the chip architecture and here the value 10^-11 is taken
cp1 = 500;
cp2 = 2000;
cp = (cp2-cp1).*rand(1,1) + cp1;
if strategy == 2     % total offloading
    f= 10; % CPU revolution per second
    Econsump = (k*power(f,2)*cp) + (cp/(f*10e8));
elseif strategy == 1  % locally
    f= 1; % CPU revolution per second
    Econsump = (k*power(f,2)*cp) + (cp/(f*10e8));
else                  %partial offloading
    f_edge = 10
    f_uav = 1;
    w = 0.9;
    Econsump = (k*power(f_edge,2)*w*cp) + ((w*cp)/(f_edge*10e8)) + (k*power(f_uav,2)*(1-w)*cp) + (((1-w)*cp)/(f_uav*10e8));
end



%Econsump = (k*power(f,2)*cp) + (cp/(f*10e8));

if beta == 0.7
    Econsump = (k*power(f,2)*cp) + 5000*(cp/(f*10e7));
elseif beta == 0.8
    Econsump = (k*power(f,2)*cp) + 6000*(cp/(f*10e8));
elseif beta == 0.9
    Econsump = (k*power(f,2)*cp) + cp/(f*10e10);
else
    Econsump = (k*power(f,2)*cp) + cp/(f*10e2);
end


end