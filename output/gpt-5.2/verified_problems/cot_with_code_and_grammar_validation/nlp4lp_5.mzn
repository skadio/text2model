% Parameters
int: NumLinks;
set of int: LINKS = 1..NumLinks;

array[LINKS] of int: StartNode;
array[LINKS] of int: EndNode;
array[LINKS] of int: Capacity;
array[LINKS] of int: Cost;

int: NumFlowReqs;
set of int: FLOWS = 1..NumFlowReqs;

array[FLOWS] of int: SourceNode;
array[FLOWS] of int: DestinationNode;
array[FLOWS] of int: DataRate;

% Derive number of nodes from all node indices appearing in the data
int: NumNodes = max(
  max([StartNode[l] | l in LINKS] ++ [EndNode[l] | l in LINKS]),
  max([SourceNode[f] | f in FLOWS] ++ [DestinationNode[f] | f in FLOWS])
);
set of int: NODES = 1..NumNodes;

% Variables: flow on each link for each commodity (flow requirement)
array[FLOWS, LINKS] of var 0..max(Capacity): x;

% Constraints

% Link capacity constraints (shared across all flows)
constraint forall(l in LINKS) (
  sum(f in FLOWS)(x[f,l]) <= Capacity[l]
);

% Flow conservation for each flow at each node:
% inflow - outflow = +demand at destination, -demand at source, 0 otherwise
constraint forall(f in FLOWS, n in NODES) (
  sum(l in LINKS where EndNode[l] == n)(x[f,l])
  - sum(l in LINKS where StartNode[l] == n)(x[f,l])
  =
  (if n == DestinationNode[f] then DataRate[f] else 0 endif)
  - (if n == SourceNode[f] then DataRate[f] else 0 endif)
);

% Objective: minimize total cost
solve minimize sum(f in FLOWS, l in LINKS)(Cost[l] * x[f,l]);