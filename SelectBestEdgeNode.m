function [best_index, best_cost] = SelectBestEdgeNode(initialEdgeSelection, edgNodesMat,alpha,beta, currentBestEdge)
% initialEdgeSelection consists nearby edge nodes within 100 mete and less

lessDistance = 10;
for i=1:numel(initialEdgeSelection)
        if edgNodesMat(initialEdgeSelection(i),5) < lessDistance 
            initialEdgeSelectionnew(i) = initialEdgeSelection(i);
        end
end

numInitSelection = numel(initialEdgeSelectionnew); % number of edge nodes within 100 meter and less

%when there is no edge node around
if numInitSelection == 0

end

if numInitSelection == 1
    best_index = edgNodesMat(initialEdgeSelection(numInitSelection),1);
    best_cost = alpha*edgNodesMat(initialEdgeSelectionnew(numInitSelection),5) + beta*edgNodesMat(initialEdgeSelectionnew(numInitSelection),7); %calculate cost
end
%settin up processing capability for edge nodes selected in the first step
cp1 = 1;
cp2 = 10;
for i=1:numInitSelection
    cp = (cp2-cp1).*rand(1,1) + cp1;
    processingCapability(i) = round(cp);
end

minCost = 100;
% alpha = 0.4;
% beta = 0.6;
%c = 0.3;
if numInitSelection > 1
    for i = 1:numInitSelection
        j = initialEdgeSelection(i);
        if j==currentBestEdge
            %if processingCapability(i) >= 2
                totalCost(j) = alpha*edgNodesMat(j,5) + beta*edgNodesMat(j,7); %calculate cost
                best_index = j;
                best_cost = totalCost(j);
                %best_cost = minCost;
                break;
            %end
        end
        if processingCapability(i) >= 2 %if processin capability is more than 2mb/s
            %calculate cost 
            % edgNodesMat(j,5):current distance
            %edgNodesMat(j,7): current energy
            totalCost(j) = alpha*edgNodesMat(j,5) + beta*edgNodesMat(j,7); 
    
            if minCost > totalCost(j)
                best_index = j;
                minCost = totalCost(j);
                best_cost = minCost;
            end
        end

    end %for

end %if


end %function