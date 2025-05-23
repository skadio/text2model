include "globals.mzn";

% Parameters
int: NumLinks;
array[1..NumLinks] of int: StartNode;
array[1..NumLinks] of int: EndNode;
array[1..NumLinks] of int: Capacity;
array[1..NumLinks] of int: Cost;
int: NumFlowReqs;
array[1..NumFlowReqs] of int: SourceNode;
array[1..NumFlowReqs] of int: DestinationNode;
array[1..NumFlowReqs] of int: DataRate;

% Variables
array[1..NumLinks, 1..NumFlowReqs] of var 0..Capacity: Flow;

% Constraints
constraint forall(k in 1..NumFlowReqs)(
  sum(i in 1..NumLinks where StartNode[i] = SourceNode[k])(Flow[i,k]) = DataRate[k]
);

constraint forall(k in 1..NumFlowReqs)(
  sum(i in 1..NumLinks where EndNode[i] = DestinationNode[k])(Flow[i,k]) = DataRate[k]
);

constraint forall(i in 1..NumLinks)(
  sum(k in 1..NumFlowReqs)(Flow[i,k]) <= Capacity[i]
);

% Objective
var int: TotalCost = sum(i in 1..NumLinks, k in 1..NumFlowReqs)(Cost[i]*Flow[i,k]);
solve minimize TotalCost;

% Output
output ["Total Cost: ", show(TotalCost), "\n"] ++
["Flow: "] ++ [show(Flow[i,k]) | i in 1..NumLinks, k in 1..NumFlowReqs];