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
constraint forall(i in 1..NumLinks, j in 1..NumFlowReqs) (
    Flow[i,j] <= Capacity[i]
);

constraint forall(j in 1..NumFlowReqs) (
    sum(i in 1..NumLinks where StartNode[i] = SourceNode[j]) (Flow[i,j]) = DataRate[j]
);

constraint forall(j in 1..NumFlowReqs) (
    sum(i in 1..NumLinks where EndNode[i] = DestinationNode[j]) (Flow[i,j]) = DataRate[j]
);

% Objective
var int: TotalCost = sum(i in 1..NumLinks, j in 1..NumFlowReqs) (Flow[i,j] * Cost[i]);
solve minimize TotalCost;