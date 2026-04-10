% Maximum flow in a directed capacitated network (8 nodes)

int: N = 8;
set of int: V = 0..N-1;
int: source = 0;
int: sink   = 7;

% Capacity matrix (MW); 0 means no arc.
% Use array2d to coerce the literal (1..N,1..N) into (0..N-1,0..N-1).
array[V, V] of int: cap =
  array2d(V, V,
  [  0, 19,  4,  1,  9, 13,  8, 20,
    10,  0, 12, 12,  8, 12,  7,  7,
    13, 11,  0,  8,  4,  1,  2,  3,
     4, 12, 13,  0, 18,  6, 19,  8,
     9, 16,  2,  0,  0, 14, 18,  7,
    10, 11,  7, 11, 16,  0, 16,  5,
    14, 11,  9, 11,  3, 17,  0, 19,
    12, 20,  5, 11, 10,  4,  6,  0 ]);

int: total_cap_out_source = sum(j in V)(cap[source, j]);

array[V, V] of var 0..total_cap_out_source: flow;
var 0..total_cap_out_source: max_flow;

% Capacity constraints (also forces flow=0 when cap=0)
constraint forall(i in V, j in V) (flow[i,j] <= cap[i,j]);

% No self-loops
constraint forall(i in V) (flow[i,i] = 0);

% Flow conservation for intermediate nodes
constraint
  forall(k in V where k != source /\ k != sink) (
    sum(i in V)(flow[i,k]) = sum(j in V)(flow[k,j])
  );

% Define max_flow as net flow out of source (equivalently into sink under conservation)
constraint max_flow = sum(j in V)(flow[source,j]) - sum(i in V)(flow[i,source]);
constraint max_flow = sum(i in V)(flow[i,sink])   - sum(j in V)(flow[sink,j]);

solve maximize max_flow;

output [
  "max_flow=", show(max_flow), "\n"
];