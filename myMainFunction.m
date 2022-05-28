%function myMainFunction
clc
clear
close all;
%*************************
% 1: locally
% 2: total offloading
% 3: partial offloading
strategy = 2;

% 1: based cost function (alpha = 0.3, beta=0.7)
% 2: based cost function (alpha = 0.2, beta=0.8)
% 3: based cost function (alpha = 0.1, beta=0.9)
% 4: randomly
EdgeSelectionMethod = 1; 

if EdgeSelectionMethod == 1
    alpha = 0.3;
    beta = 0.7;
elseif EdgeSelectionMethod == 2
    alpha = 0.2;
    beta = 0.8;
 elseif EdgeSelectionMethod == 3
    alpha = 0.1;
    beta = 0.9;

end


% initial position for edge nodes
xnodes=[3  5 20 10 15 20 30 27 35 40];% X-coordinate of edge nodes
ynodes=[30 9 27 15 35 2  10 40 25 36];% Y-coordinate of edge nodes
rnodes=[0.6 0.6 0.6 0.6 0.6 0.6 0.6 0.6 0.6 0.6];%radius of edge nodes used for drawing in plot only 
pnodes=[5  5  5  5  5  5  5  5 5 5]; %initial power of edge nodes
computime = [3 4 3 5 4 6 9 3 7 5]; %initial processing capability for edge nodes randomly [1-10] MB/sec

% initial position for UAV
xobs=1.5;
yobs=2.3;
robs=0.5;

%setting up a matrix to store edge node positions, current distanace from UAV,
%initial distance from UAV, current energy, initial energy, initial
%processing capability of each edge node
numberofEdgeNodes = numel(xnodes);
edgNodesMat = zeros(numberofEdgeNodes,8);
for i=1:numberofEdgeNodes
    edgNodesMat(i,1) = i; % index
    edgNodesMat(i,2) = xnodes(i); % X-coordinate
    edgNodesMat(i,3) = ynodes(i); % Y-coordinate
    edgNodesMat(i,4) = DistanetoUAV(xnodes(i),ynodes(i),xobs,yobs); % intital distance to UAV
    edgNodesMat(i,5) = edgNodesMat(i,4); % current distance to UAV
    edgNodesMat(i,6) = pnodes(i); % intital power of edge node
    edgNodesMat(i,7) = pnodes(i); % current power of edge node
    edgNodesMat(i,8) = computime(i); % current processing capability

end
% setting up a matrix to save all commuication between UAV and edge nodes
% during its trajectory
AllBestEdgeSelectionMat = zeros(100,4);
AllBestEdgeSelectionMat(1,1) = xobs;
AllBestEdgeSelectionMat(1,2) = yobs;
min = 100;
for i=1:numberofEdgeNodes
   if edgNodesMat(i,4) < min 
      index = edgNodesMat(i,1); % intial selection of edge has distance less than 10m to UAV
      min = edgNodesMat(i,4);
   end
end
AllBestEdgeSelectionMat(1,3) = index;
AllBestEdgeSelectionMat(1,4) = edgNodesMat(index,4);

% drawing  position OF edge nodes
theta=linspace(0,2*pi,100);
N = numel(xnodes);
% create an array of handles to the fill objects (circles)
hFillNodes = zeros(N,1);
for k=1:N
    hFillNodes(k) = fill(xnodes(k)+rnodes(k)*cos(theta),ynodes(k)+rnodes(k)*sin(theta),[1 1 1]);
    hold on;
end



%drawing position OF UAV
theta=linspace(0,2*pi,100);
N = numel(xobs);
% create an array of handles to the fill objects (circles)
hFill = zeros(N,1);
for k=1:N
    hFill(k) = fill(xobs(k)+robs(k)*cos(theta),yobs(k)+robs(k)*sin(theta),[0 1 0]);
    hold on;
end


lessDistance = 10;
%totalRemainPow = 0;
jj = 1;
ii = 2;
% set some arbitraty limits on the axes
ylim([0 50])
xlim([0 50])

while (xobs<40 || yobs<40) %true
    % call your linear motion function - the output replaces the input
    [xobs, yobs] = motionlinear(xobs, yobs);
    AllBestEdgeSelectionMat(ii,1) = xobs;
    AllBestEdgeSelectionMat(ii,2) = yobs;
    
    bestindexofEdge = 0;
    k = 1;
    %initialEdgeSelection = zeros(1,10);
    for i=1:numberofEdgeNodes
        edgNodesMat(i,5) = DistanetoUAV(xnodes(i),ynodes(i),xobs,yobs);
        if edgNodesMat(i,5) < lessDistance 
           initialEdgeSelection(k) = edgNodesMat(i,1); % intial selection of edge has distance less than 10m to UAV
           k = k+1;
        end
    end


    if EdgeSelectionMethod == 4
        %Select nearby edge node randomly
        [best_index, best_cost] = SelectEdgeNodeRandom(initialEdgeSelection, edgNodesMat);
    else
        %Select best nearby edge node by cost function
        [best_index, best_cost] = SelectBestEdgeNode(initialEdgeSelection, edgNodesMat,alpha,beta, AllBestEdgeSelectionMat(ii-1,3));
    end


    %update matrix based on new edge node selection
    AllBestEdgeSelectionMat(ii,3) = best_index;
    AllBestEdgeSelectionMat(ii,4) = edgNodesMat(best_index,5);
    ii = ii+1;

    %stor best cost
    BestCost(jj,1) = best_cost;
    
    %calculate energy consumption
    if EdgeSelectionMethod == 4 % randomly edge node selection
        Econsump  = computeEnergyConusmption(0, strategy);
    else
        Econsump  = computeEnergyConusmption(beta, strategy);
    end
    edgNodesMat(best_index,7) = edgNodesMat(best_index,7) - Econsump;
    
     totalRemainPow(jj,1) =  Econsump;
     jj = jj + 1;
%      for i=1:numel(pnodes)
%          totalRemainPow = totalRemainPow + pnodes(i);
%      end
     %txt = ['The total power is: ',num2str(totalRemainPow)];
    
    for k = 1:N
        % updated the x and y data for each fill object
        set(hFill(k), 'XData', xobs(k)+robs(k)*cos(theta), 'YData', yobs(k)+robs(k)*sin(theta));
        hold on
        plot(xobs,yobs,'r.','LineWidth', 1);
        hold on
        %text(10,45,txt)
        
    end
    
    for j= 1:numel(xnodes)
        if (ismember(j, initialEdgeSelection)) && (j == best_index)
            hFillNodes(j) = fill(xnodes(j)+rnodes(j)*cos(theta),ynodes(j)+rnodes(j)*sin(theta),[1 0 0]);
        elseif (ismember(j, initialEdgeSelection)) && (j ~= best_index)
            hFillNodes(j) = fill(xnodes(j)+rnodes(j)*cos(theta),ynodes(j)+rnodes(j)*sin(theta),[1 1 0]);
        else
            hFillNodes(j) = fill(xnodes(j)+rnodes(j)*cos(theta),ynodes(j)+rnodes(j)*sin(theta),[1 1 1]);
        end
    end
    
    
    
    pause(0.1); 
end


if EdgeSelectionMethod == 4 % randomly selection
    writematrix(AllBestEdgeSelectionMat,'RandomEdgeSelectionMat.csv');
    writematrix(edgNodesMat,'RandomedgNodesMat.csv');
    writematrix(totalRemainPow,'RandomConsumePow.csv');
else  % otherwise
    writematrix(AllBestEdgeSelectionMat,'AllBestEdgeSelectionMat.csv');
    writematrix(edgNodesMat,'edgNodesMat.csv');
    writematrix(totalRemainPow,'ConsumePow1.csv');
end

k = 1;
z = 3;
sume = 0;
sumCost = 0;
n = numel(totalRemainPow);
for i=1:30
    
    for j=k:z
        sume = sume + totalRemainPow(j,1);
        sumCost = sumCost + BestCost(j,1);
    end
    energyCost(i) = sume;
    totalCost(i) = sumCost;
    if i<=11
        k = k+3;
        z = z+3;
    elseif i ==12
        k = k+3;
        z = z+4;
    else
        k = k+4;
        z = z+4;
    end
end

writematrix(energyCost,'EnergyConsume5.csv');
writematrix(totalCost,'totalCost5.csv');
% figure(2)
% plot(energyCost)


