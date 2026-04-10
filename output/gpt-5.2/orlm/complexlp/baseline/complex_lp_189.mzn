% Maximum flow in a directed graph with embedded data

int: N = 4;
set of int: V = 1..N;

int: source = 1;
int: sink = 4;

% Capacity matrix (0 means no edge)
array[V, V] of int: cap =
[
  % to: 1  2  3  4
        0, 8, 7, 0,  % from 1
        0, 0, 2, 4,  % from 2
        0, 0, 0, 12, % from 3
        0, 0, 0, 0   % from 4
];

% Flow variables
array[V, V] of var 0..max(cap): f;

% No flow on non-edges, and capacity constraints on edges
constraint
  forall(i in V, j in V) (
    (cap[i,j] = 0 -> f[i,j] = 0) /\
    (cap[i,j] > 0 -> f[i,j] <= cap[i,j])
  );

% Flow conservation for intermediate nodes
constraint
  forall(v in V where v != source /\ v != sink) (
    sum(i in V)(f[i,v]) = sum(j in V)(f[v,j])
  );

% Objective: maximize total flow out of source (equivalently into sink)
var 0..sum(j in V)(cap[source,j]): maxflow = sum(j in V)(f[source,j]);

solve maximize maxflow;

output [
  "max_flow = ", show(maxflow), "\n",
  "flows:\n"
] ++
[
  if cap[i,j] > 0 then
    "  f(" ++ show(i) ++ "->" ++ show(j) ++ ") = " ++ show(f[i,j]) ++
    " / " ++ show(cap[i,j]) ++ "\n"
  else "" endif
  | i in V, j in V
];