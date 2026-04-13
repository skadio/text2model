% Maximum flow in a directed capacitated network (nodes 0..8)

% Parameters
int: N = 9;
set of int: V = 0..N-1;
int: s = 0;
int: t = 8;

% Capacity matrix (coerced to index set 0..8 x 0..8)
array[V, V] of int: cap =
  array2d(V, V,
    [  0,  9,  7, 18,  0,  0,  7,  0,  2,
      15,  0, 11,  5, 20, 15, 18,  9, 15,
       3,  8,  0, 10, 16, 18,  8,  0, 20,
      13,  3,  7,  0, 20, 13, 16,  6, 20,
       7, 20,  2,  4,  0,  9,  3, 14,  2,
      17, 10,  5,  1,  4,  0,  4,  3, 20,
       0, 20, 10, 10, 15,  5,  0,  1, 10,
      10,  3,  9,  4,  3, 13, 18,  0, 20,
       2, 12, 10,  5, 15, 14,  0, 10,  0 ]
  );

int: maxCap = max([cap[i,j] | i in V, j in V]);
int: flow_ub = (N-1) * maxCap;

% Variables
array[V, V] of var 0..flow_ub: f;
var 0..flow_ub: totalFlow;

% Capacity constraints (also forces f[i,j]=0 when cap[i,j]=0)
constraint forall(i in V, j in V) (
  f[i,j] <= cap[i,j]
);

% No self-loops
constraint forall(i in V) (
  f[i,i] = 0
);

% Flow conservation at intermediate nodes
constraint forall(v in V where v != s /\ v != t) (
  sum(i in V)(f[i,v]) = sum(j in V)(f[v,j])
);

% Define total flow (net outflow from source and net inflow to sink)
constraint totalFlow = sum(j in V)(f[s,j]) - sum(i in V)(f[i,s]);
constraint totalFlow = sum(i in V)(f[i,t]) - sum(j in V)(f[t,j]);

solve maximize totalFlow;

output [
  "totalFlow=", show(totalFlow), "\n"
];