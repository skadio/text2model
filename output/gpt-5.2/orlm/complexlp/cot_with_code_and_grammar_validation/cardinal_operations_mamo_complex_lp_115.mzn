% Maximum flow from source s to sink t in a directed capacitated network

int: N = 7;
set of int: V = 0..N-1;

int: s = 0;
int: t = 6;

% Capacity matrix (0 means no arc)
array[V, V] of int: cap = array2d(V, V,
[
  0, 20, 19, 18,  0, 11,  2,
  18,  0, 15, 10,  0,  9,  0,
  18,  4,  0, 11, 15,  0, 13,
  17,  3, 15,  0,  2,  4,  4,
   2, 11, 17, 17,  0,  2, 17,
  12,  4, 16, 13,  5,  0,  3,
   7,  9, 17, 18, 16,  8,  0
]);

int: maxCap = max([cap[i,j] | i in V, j in V]);

% Flow variables on each arc
array[V, V] of var 0..maxCap: f;

% Total flow value
var 0..sum(j in V)(cap[s,j]): total_flow;

% Capacity constraints (also forces f[i,j]=0 when cap[i,j]=0)
constraint forall(i in V, j in V) (
  f[i,j] <= cap[i,j]
);

% Flow conservation at intermediate nodes
constraint forall(i in V where i != s /\ i != t) (
  sum(j in V)(f[i,j]) = sum(j in V)(f[j,i])
);

% Define total flow as net outflow from source and net inflow to sink
constraint total_flow = sum(j in V)(f[s,j]) - sum(j in V)(f[j,s]);
constraint total_flow = sum(j in V)(f[j,t]) - sum(j in V)(f[t,j]);

solve maximize total_flow;

output [
  "max_flow = ", show(total_flow), "\n"
];