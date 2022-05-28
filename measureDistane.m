function [index_node, best_index] = measureDistane(xobs, yobs, pnodes)

xnodes=[3  5 10 10 15 20 30 27 35 40];%30 32 35 37 39 46 42 45 47 49 20 25 22 10 15 15 40];
ynodes=[30 9 22 15 35 2  10 40 25 36];%27 5  33 47 7  43 4  14 25 4  20 15 30 45 40 5  38];
%pnodes=[5  2  3  4  5  2  1  4  3  3  3  2  1  3  4  4  4  2  2  2  2  5  1  5  3 ];
exist = 0;
dist = 100;
j = 1;
N = numel(xnodes);
distance = zeros(N,1);
%index_node = zeros(N,1);
for i=1:N
distance(i) = sqrt((xnodes(i)-xobs)^2 + (ynodes(i)-yobs)^2);
if distance(i)< 50
    index_node(j) = i;
    exist = 1;
    j = j+1;
end
end

powdist = 0;
a1 = 0.3; % weight for distance
a2 = 0.7; % weight for energy
pow = 0;
%if exist == 1
    for i=1:numel(index_node)
        %if distance(i)<10
            powdist = a1*distance(index_node(i)) + a2*pnodes(index_node(i));
        %end
        if powdist > pow 
            best_index = index_node(i);
            pow = powdist;
        end
    end
%end





%index_node = j;