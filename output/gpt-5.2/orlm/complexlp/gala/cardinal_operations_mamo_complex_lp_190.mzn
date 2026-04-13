include "globals.mzn";

% Maximum flow in a directed network (all data embedded)

int: N = 4;
set of int: V = 1..N;

int: s = 1;   % source
int: t = 4;   % sink

% Capacity matrix (0 means no arc)
array[V, V] of int: cap =
  array2d(V, V, [
    0, 5, 7, 0,
    0, 0, 2, 4,
    0, 0, 0, 12,
    0, 0, 0, 0
  ]);

% Flow variables: 0 <= f(i,j) <= cap(i,j)
array[V, V] of var 0..max(cap): f;

constraint
  forall(i in V, j in V) (
    f[i,j] <= cap[i,j]
  );

% Flow conservation at intermediate nodes (all except source and sink)
constraint
  forall(v in V where v != s /\ v != t) (
    sum(i in V)(f[i,v]) = sum(j in V)(f[v,j])
  );

% Define total flow value as net outflow from source (equivalently inflow to sink)
var 0..sum(j in V)(cap[s,j]): F;
constraint F = sum(j in V)(f[s,j]) - sum(i in V)(f[i,s]);
constraint F = sum(i in V)(f[i,t]) - sum(j in V)(f[t,j]);

solve maximize F;

output [
  "MaxFlow = ", show(F), "\n",
  "Flow matrix f(i,j):\n",
  concat([ concat([ if j==1 then "" else " " endif ++ show(f[i,j]) | j in V ]) ++ "\n" | i in V ])
];