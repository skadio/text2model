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
  sum(j in 1..NumLinks)(if StartNode[j] = SourceNode[i] then Flow[j, i] else -Flow[j, i] endif) = DataRate[i]
);
constraint forall(i in 1..NumFlowReqs)(
  sum(j in 1..NumLinks)(if EndNode[j] = DestinationNode[i] then Flow[j, i] else -Flow[j, i] endif) = DataRate[i]
);
constraint forall(j in 1..NumLinks)(
  sum(i in 1..NumFlowReqs)(Flow[j, i]) <= Capacity[j]
);

% Objective
var int: TotalCost = sum(j in 1..NumLinks, i in 1..NumFlowReqs)(Flow[j, i] * Cost[j]);
solve minimize TotalCost;