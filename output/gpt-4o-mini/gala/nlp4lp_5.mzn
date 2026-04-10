include "globals.mzn";

int: NumLinks;                          % Number of links
array[1..NumLinks] of int: StartNode;  % Starting nodes for each link
array[1..NumLinks] of int: EndNode;    % Ending nodes for each link
array[1..NumLinks] of int: Capacity;    % Capacities for each link
array[1..NumLinks] of int: Cost;        % Costs for each link

int: NumFlowReqs;                       % Number of data flow requirements
array[1..NumFlowReqs] of int: SourceNode;        % Source nodes for data flow
array[1..NumFlowReqs] of int: DestinationNode;   % Destination nodes for data flow
array[1..NumFlowReqs] of int: DataRate;          % Data rates for each flow

% Variables
array[1..NumLinks] of var 0..Capacity: flow;  % Flow on each link

% Objective: Minimize total cost
var int: totalCost = sum(i in 1..NumLinks)(flow[i] * Cost[i]);

% Constraints
% Ensure that the flow requirements are satisfied
array[1..NumFlowReqs] of var 0..sum(Capacity): totalFlow; % Total flow for each requirement

% Flow conservation constraints
constraint forall(k in 1..NumFlowReqs) (
    totalFlow[k] = sum(i in 1..NumLinks where StartNode[i] == SourceNode[k])(flow[i]) -
                   sum(i in 1..NumLinks where EndNode[i] == SourceNode[k])(flow[i])
);

% Ensure that the total flow from source to destination meets the data rate
constraint forall(k in 1..NumFlowReqs) (
    totalFlow[k] >= DataRate[k]
);

% Capacity constraints
constraint forall(i in 1..NumLinks) (
    flow[i] <= Capacity[i]
);

% Solve & output
solve minimize totalCost;
output [ "Total Cost = ", show(totalCost), "\nFlow on each link = ", show(flow), "\n" ];