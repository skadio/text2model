% Max flow in a directed capacitated network (CyberCity)
int: N = 8;
set of int: V = 0..N-1;
int: source = 0;
int: sink = 7;

% Capacity matrix cap[i,j] (Tbps). 0 means no direct link.
% Use array2d to ensure 0-based index sets (fixes index set mismatch).
array[V, V] of int: cap = array2d(V, V, [
   0,  3,  3,  5, 13,  7, 14, 17,
   5,  0,  0,  2, 18, 20,  1, 17,
   2, 18,  0, 10, 14, 15,  8, 18,
  20,  7, 11,  0, 13,  2,  8, 12,
  20, 20, 12,  7,  0, 11,  2, 14,
   5, 16, 15, 19, 11,  0,  1,  8,
  10,  3, 14, 18, 13,  6,  0,  7,
   9,  3, 14, 13,  6,  5,  9,  0
]);

% Upper bound on flow: total capacity leaving the source
int: UB_flow = sum(j in V)(cap[source, j]);

% Decision variables
array[V, V] of var 0..UB_flow: flow;
var 0..UB_flow: max_flow;

% Capacity constraints (includes forcing flow=0 when cap=0)
constraint forall(i in V, j in V) (
  flow[i,j] <= cap[i,j]
);

% No self-loop flow
constraint forall(i in V) (flow[i,i] = 0);

% Flow conservation at intermediate nodes
constraint forall(v in V where v != source /\ v != sink) (
  sum(i in V)(flow[i,v]) = sum(j in V)(flow[v,j])
);

% Define max_flow as net outflow from source and net inflow to sink
constraint max_flow = sum(j in V)(flow[source, j]) - sum(i in V)(flow[i, source]);
constraint max_flow = sum(i in V)(flow[i, sink]) - sum(j in V)(flow[sink, j]);

solve maximize max_flow;

output ["max_flow = \(max_flow)\n"];