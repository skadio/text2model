include "globals.mzn";

% Maximum flow on a fixed directed graph with 4 nodes and given arc capacities.
% Nodes: 1 = source, 4 = sink
int: N = 4;
int: s = 1;
int: t = 4;

% Enumerate arcs (u[a] -> v[a]) with capacities cap[a]
int: A = 5;
array[1..A] of int: u   = [1, 1, 2, 2, 3];
array[1..A] of int: v   = [2, 3, 3, 4, 4];
array[1..A] of int: cap = [8, 7, 2, 4, 7];

% Decision variables: flow on each arc
array[1..A] of var 0..max(cap): f;

% Capacity constraints
constraint forall(a in 1..A) (f[a] <= cap[a]);

% Flow conservation at intermediate nodes (all nodes except s and t)
constraint forall(n in 1..N where n != s /\ n != t) (
  sum(a in 1..A where v[a] == n)(f[a]) = sum(a in 1..A where u[a] == n)(f[a])
);

% Objective: maximize total flow into sink (equivalently out of source)
var 0..sum(cap): maxflow = sum(a in 1..A where v[a] == t)(f[a]);

solve maximize maxflow;

output [
  "Max flow (rounded to nearest integer) = ", show(fix(maxflow)), "\n",
  "Arc flows (u->v : flow/cap):\n"
] ++
[
  show(u[a]) ++ "->" ++ show(v[a]) ++ " : " ++ show(f[a]) ++ "/" ++ show(cap[a]) ++ "\n"
  | a in 1..A
];