include "globals.mzn";

% Maximum flow on a directed graph with given capacities (all data embedded).

int: N = 4;
set of int: V = 1..N;

int: S = 1;
int: T = 4;

% Directed edges (u[e] -> v[e]) with capacity cap[e]
int: E = 5;
set of int: Edges = 1..E;

array[Edges] of int: u   = [1, 1, 2, 2, 3];
array[Edges] of int: v   = [2, 3, 3, 4, 4];
array[Edges] of int: cap = [8, 7, 2, 4, 12];

% Flow on each edge
array[Edges] of var 0..max(cap): f;

% Capacity constraints
constraint forall(e in Edges)(f[e] <= cap[e]);

% Flow conservation at intermediate nodes
constraint forall(n in V where n != S /\ n != T)(
  sum(e in Edges where v[e] = n)(f[e]) = sum(e in Edges where u[e] = n)(f[e])
);

% Total flow value (out of source = into sink)
var 0..sum(e in Edges where u[e] = S)(cap[e]): F;
constraint F = sum(e in Edges where u[e] = S)(f[e]);
constraint F = sum(e in Edges where v[e] = T)(f[e]);

solve maximize F;

output [
  "MaxFlow = ", show(F), "\n",
  "Edge flows (u->v : flow/cap):\n",
  concat([ show(u[e]) ++ "->" ++ show(v[e]) ++ " : " ++ show(f[e]) ++ "/" ++ show(cap[e]) ++ "\n"
           | e in Edges ])
];