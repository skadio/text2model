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
array[1..NumLinks, 1..NumFlowReqs] of var 0..max(Capacity): Flow;

% Constraints
constraint forall(i in 1..NumFlowReqs)(
  sum(j in 1..NumLinks where StartNode[j] = SourceNode[i])(Flow[j, i]) = DataRate[i]
);
constraint forall(i in 1..NumFlowReqs)(
  sum(j in 1..NumLinks where EndNode[j] = DestinationNode[i])(Flow[j, i]) = DataRate[i]
);
constraint forall(j in 1..NumLinks)(
  sum(i in 1..NumFlowReqs)(Flow[j, i]) <= Capacity[j]
);

% Objective
var int: TotalCost = sum(i in 1..NumLinks, j in 1..NumFlowReqs)(Flow[i, j] * Cost[i]);
solve minimize TotalCost;