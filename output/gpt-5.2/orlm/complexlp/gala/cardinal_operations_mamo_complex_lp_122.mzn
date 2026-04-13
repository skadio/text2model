include "globals.mzn";

% Max flow from source s=0 to sink t=7 on a directed network with capacities.
% Data is embedded as requested.

int: n = 8;
set of int: V = 0..n-1;
int: s = 0;
int: t = 7;

array[V, V] of int: cap =
[
% to:   0   1   2   3   4   5   6   7
/*0*/ [ 0, 15, 19,  4,  4,  3, 20, 17],
/*1*/ [ 8,  0,  6,  5, 20,  3, 15,  1],
/*2*/ [11, 13,  0, 16, 15,  7, 10, 13],
/*3*/ [17, 20,  6,  0, 11,  3,  2,  0],
/*4*/ [10, 15,  5,  0,  0,  9,  9, 15],
/*5*/ [ 9, 17,  5,  1,  9,  0, 20,  2],
/*6*/ [ 4, 16, 10,  2,  1,  6,  0,  4],
/*7*/ [ 0,  0,  0,  0,  0,  0,  0,  0]
];

int: max_cap = max([cap[i,j] | i in V, j in V]);

% flow[i,j] is amount sent on arc i->j (0 if no arc or unused)
array[V, V] of var 0..max_cap: flow;

% Capacity constraints and enforce 0 flow on non-arcs (including self-arcs)
constraint forall(i in V, j in V) (
  flow[i,j] <= cap[i,j]
);

% Flow conservation on intermediate nodes (excluding source and sink)
constraint forall(v in V where v != s /\ v != t) (
  sum(i in V)(flow[i,v]) = sum(j in V)(flow[v,j])
);

% Objective: maximize total flow leaving the source (equivalently entering sink)
var 0..sum(j in V)(cap[s,j]): total_flow = sum(j in V)(flow[s,j]);

solve maximize total_flow;

output [
  "Maximum flow from hub ", show(s), " to hub ", show(t), " = ",
  show(total_flow), "\n",
  "Flow matrix (rows=from, cols=to):\n",
  show(flow), "\n"
];