include "globals.mzn";

% Max flow from source s=0 to sink t=5 on a directed graph with capacities.
% Data embedded as required.

int: n = 6;
set of int: V = 0..n-1;

int: s = 0;
int: t = 5;

array[V, V] of int: cap =
[
% to:   0   1   2   3   4   5
/*0*/ [  0, 14, 15, 13,  0,  4],
/*1*/ [ 10,  0,  7, 18,  9,  5],
/*2*/ [ 11,  0,  0,  7, 13,  6],
/*3*/ [  7, 11, 18,  0, 17,  2],
/*4*/ [ 19,  8, 15, 15,  0,  5],
/*5*/ [ 10, 19, 17,  2,  3,  0]
];

% Decision variables: flow on each directed arc
int: U = max([cap[i,j] | i in V, j in V]); % max single-arc capacity
array[V, V] of var 0..U: f;

% Capacity constraints (and force f=0 when no arc)
constraint forall(i in V, j in V) (
  f[i,j] <= cap[i,j]
);

% Flow conservation for all intermediate nodes
constraint forall(k in V where k != s /\ k != t) (
  sum(i in V)(f[i,k]) = sum(j in V)(f[k,j])
);

% Objective: maximize total flow out of source (equivalently into sink)
var 0..sum(j in V)(cap[s,j]): maxFlow = sum(j in V)(f[s,j]);

solve maximize maxFlow;

output [
  "Maximum trucks per hour from City ", show(s), " to City ", show(t), " = ",
  show(maxFlow), "\n",
  "Flow matrix f[i,j] (i=row -> j=col):\n",
  show([ [ fix(f[i,j]) | j in V ] | i in V ]), "\n"
];