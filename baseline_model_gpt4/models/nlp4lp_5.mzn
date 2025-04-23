include "globals.mzn";

% Number of links
int: NumLinks;

% Starting node for each link
array[1..NumLinks] of int: StartNode;

% Ending node for each link
array[1..NumLinks] of int: EndNode;

% Maximum capacity for each link
array[1..NumLinks] of int: Capacity;

% Cost for transporting data through each link
array[1..NumLinks] of int: Cost;

% Number of data flow requirements
int: NumFlowReqs;

% Source node for each data flow
array[1..NumFlowReqs] of int: SourceNode;

% Destination node for each data flow
array[1..NumFlowReqs] of int: DestinationNode;

% Rate of data flow for each flow
array[1..NumFlowReqs] of int: DataRate;

% Variables
array[1..NumLinks, 1..NumFlowReqs] of var 0..Capacity: Flow;

% Objective
var int: TotalCost = sum(i in 1..NumLinks, j in 1..NumFlowReqs)(Flow[i,j] * Cost[i]);

% Constraints
constraint forall(i in 1..NumFlowReqs)(
  sum(j in 1..NumLinks)(Flow[j,i] * (StartNode[j] = SourceNode[i])) = DataRate[i]
);

constraint forall(i in 1..NumFlowReqs)(
  sum(j in 1..NumLinks)(Flow[j,i] * (EndNode[j] = DestinationNode[i])) = DataRate[i]
);

constraint forall(i in 1..NumLinks)(
  sum(j in 1..NumFlowReqs)(Flow[i,j]) <= Capacity[i]
);

% Solve
solve minimize TotalCost;

% Output
output ["Total cost: ", show(TotalCost), "\n"] ++
["Flow: ", show(Flow), "\n"];