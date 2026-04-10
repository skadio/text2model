% Parameters
% -----------------------------
% Number of nodes
int: N = 4;
set of int: Nodes = 1..N;

% Source and sink nodes
int: source = 1;
int: sink = 4;

% Directed edge capacities (capacity[i,j] = max flow allowed on arc i->j)
array[Nodes, Nodes] of int: capacity =
  [| 0, 8, 7, 0
   | 0, 0, 2, 4
   | 0, 0, 0, 7
   | 0, 0, 0, 0
  |];

% Variables
% -----------------------------
% Flow on each directed arc i->j (bounded by capacity; 0 if no arc)
% Upper bound chosen as max capacity in the instance (=8)
array[Nodes, Nodes] of var 0..8: flow;

% Total flow value from source to sink (integer max flow)
% Upper bound chosen as sum of source outgoing capacities (= 8+7 = 15)
var 0..15: maxFlowValue;

% Constraints
% -----------------------------
% Capacity bounds on all arcs (includes forcing to 0 when capacity is 0)
constraint
  forall(i in Nodes, j in Nodes) (
    flow[i,j] >= 0 /\ flow[i,j] <= capacity[i,j]
  );

% Arc feasibility: enforce zero flow on non-existent arcs (capacity = 0)
% (Redundant given the bounds above, but kept for clarity.)
constraint
  forall(i in Nodes, j in Nodes where capacity[i,j] = 0) (
    flow[i,j] = 0
  );

% Flow conservation at intermediate nodes (all except source and sink)
constraint
  forall(k in Nodes where k != source /\ k != sink) (
    sum(i in Nodes)(flow[i,k]) = sum(j in Nodes)(flow[k,j])
  );

% Source/sink consistency: flow value equals net outflow from source and net inflow to sink
constraint
  maxFlowValue = sum(j in Nodes)(flow[source,j]);

constraint
  maxFlowValue = sum(i in Nodes)(flow[i,sink]);

% No flow enters the source and no flow leaves the sink (implied by capacities but explicit)
constraint
  forall(i in Nodes) (flow[i,source] = 0);

constraint
  forall(j in Nodes) (flow[sink,j] = 0);

% Objective
% -----------------------------
solve maximize maxFlowValue;