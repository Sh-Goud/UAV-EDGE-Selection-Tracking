function [best_index, best_cost] = SelectEdgeNodeRandom(initialEdgeSelection, edgNodesMat)

numInitSelection = numel(initialEdgeSelection);

%settin up processing capability for edge nodes selected in the first step
% cp1 = 1;
% cp2 = 10;
% for i=1:numInitSelection
%     cp = (cp2-cp1).*rand(1,1) + cp1;
%     processingCapability(i) = round(cp);
% end
 alpha = 0.6;
 beta = 0.4;
%if only one edge node exist for selection
if numInitSelection == 1
    best_index = edgNodesMat(initialEdgeSelection(numInitSelection),1);
    best_cost = alpha*edgNodesMat(initialEdgeSelection(numInitSelection),5) + beta*edgNodesMat(initialEdgeSelection(numInitSelection),7); %calculate cost


end


% if more then one edge node exist for selection
if numInitSelection > 1
    a = 1;
    b = numInitSelection;
    c = (b-a).*rand(1,1) + a;
    best_index = initialEdgeSelection(round(c));
    best_cost = alpha*edgNodesMat(initialEdgeSelection(round(c)),5) + beta*edgNodesMat(initialEdgeSelection(round(c)),7); %calculate cost

end

%best_cost = 0;

end