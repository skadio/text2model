include "globals.mzn";

% Max flow from source s to sink t in a directed network with capacities.
int: n = 8;
int: s = 1; % Data Center 0 -> index 1
int: t = 8; % Data Center 7 -> index 8

% Capacity matrix cap[i,j] (Tbps); 0 means no arc.
array[1..n, 1..n] of int: cap =
[
% to:   0   1   2   3   4   5   6   7
/*0*/ [ 0,  5, 16, 11,  2, 10, 17,  2],
/*1*/ [ 8,  0, 14, 14,  2,  7, 11,  1],
/*2*/ [17, 20,  0, 16, 13,  0,  6,  1],
/*3*/ [ 3, 16, 10,  0, 19, 12,  3, 15],
/*4*/ [15, 12, 19, 18,  0, 14, 12, 15],
/*5*/ [ 2, 20, 20, 17,  4,  0, 10, 17],
/*6*/ [15, 13, 13,  5, 10, 15,  0, 19],
/*7*/ [10,  3, 14, 11,  5, 20,  4,  0]
];

int: U = sum(i in 1..n, j in 1..n)(cap[i,j]); % safe upper bound

% Decision variables: flow on each directed arc.
array[1..n, 1..n] of var 0..U: f;

% Capacity constraints and forbid self-loops / non-arcs.
constraint forall(i in 1..n, j in 1..n) (
  (i = j -> f[i,j] = 0) /\
  (cap[i,j] = 0 -> f[i,j] = 0) /\
  f[i,j] <= cap[i,j]
);

% Flow conservation at intermediate nodes.
constraint forall(k in 1..n where k != s /\ k != t) (
  sum(i in 1..n)(f[i,k]) = sum(j in 1..n)(f[k,j])
);

% Total flow value: net outflow from source (equals net inflow to sink).
var 0..U: maxflow;
constraint maxflow = sum(j in 1..n)(f[s,j]) - sum(i in 1..n)(f[i,s]);
constraint maxflow = sum(i in 1..n)(f[i,t]) - sum(j in 1..n)(f[t,j]);

solve maximize maxflow;

output [
  "Maximum flow (Tbps) = ", show(maxflow), "\n",
  "Flow matrix f (rows=from, cols=to):\n", show(f), "\n"
];