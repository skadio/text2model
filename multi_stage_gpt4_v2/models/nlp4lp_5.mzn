% Parameters
int: NumLinks; % The number of links between nodes in the network
array[1..NumLinks] of int: StartNode; % The starting node for each link
array[1..NumLinks] of int: EndNode; % The ending node for each link
array[1..NumLinks] of int: Capacity; % The maximum capacity for each link
array[1..NumLinks] of int: Cost; % The cost for transporting data through each link
int: NumFlowReqs; % The number of data flow requirements
array[1..NumFlowReqs] of int: SourceNode; % The source node for each data flow
array[1..NumFlowReqs] of int: DestinationNode; % The destination node for each data flow
array[1..NumFlowReqs] of int: DataRate; % The rate of data flow for each flow

% Variables
array[1..NumLinks, 1..NumFlowReqs] of var 0..max(Capacity): Flow; % The amount of data flow through each link for each flow requirement

% Constraints

% Constraint 1: The total flow on each link should not exceed its capacity
constraint forall(i in 1..NumLinks) (
    sum(j in 1..NumFlowReqs) (Flow[i,j]) <= Capacity[i]
);

% Constraint 2: The total flow from each source node should be equal to the data rate
constraint forall(k in 1..NumFlowReqs) (
    sum(i in 1..NumLinks) (Flow[i,k] * (StartNode[i] = SourceNode[k])) = DataRate[k]
);

% Constraint 3: The total flow into each destination node should be equal to the data rate
constraint forall(k in 1..NumFlowReqs) (
    sum(i in 1..NumLinks) (Flow[i,k] * (EndNode[i] = DestinationNode[k])) = DataRate[k]
);

% Constraint 4: The total flow into each non-source, non-destination node should be equal to the total flow out of it
constraint forall(i in 1..NumLinks, k in 1..NumFlowReqs) (
    (StartNode[i] != SourceNode[k] /\ StartNode[i] != DestinationNode[k]) -> 
    (sum(j in 1..NumLinks) (Flow[j,k] * (EndNode[j] = StartNode[i])) = sum(j in 1..NumLinks) (Flow[j,k] * (StartNode[j] = StartNode[i])))
);

% Objective
solve minimize sum(i in 1..NumLinks, j in 1..NumFlowReqs) (Flow[i,j] * Cost[i]);