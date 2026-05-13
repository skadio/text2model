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

% Derived sets
int: MaxNode = max(max(StartNode), max(EndNode));
set of int: Nodes = 1..MaxNode;
set of int: L = 1..NumLinks;
set of int: F = 1..NumFlowReqs;

% Variables
array[F, L] of var 0..Capacity[l] : flow;

% Constraints
constraint
  % Capacity constraints
  forall(l in L) (
    sum(k in F) flow[k,l] <= Capacity[l]
  )
  /\ 
  % Flow conservation
  forall(n in Nodes, k in F) (
    let {
      int: out = sum(l in L where StartNode[l] == n) flow[k,l];
      int: in_ = sum(l in L where EndNode[l] == n) flow[k,l];
      int: demand = 
        if n == SourceNode[k] then DataRate[k]
        else if n == DestinationNode[k] then -DataRate[k]
        else 0
    } in
    out - in_ == demand
  );

% Objective
solve minimize
  sum(l in L) Cost[l] * sum(k in F) flow[k,l];