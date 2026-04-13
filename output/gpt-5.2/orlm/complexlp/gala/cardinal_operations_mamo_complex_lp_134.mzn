include "globals.mzn";

% Max-flow from source s=0 to sink t=8 on a directed capacitated graph.
% Nodes are 0..8 (9 stations). Capacities are given in the description.

int: n = 9;
set of int: V = 0..n-1;
int: s = 0;
int: t = 8;

array[V, V] of int: cap =
%    to:  0  1  2  3  4  5  6  7  8
[
/*0*/ [ 0, 2, 8,17,16,20,15,12, 9],
/*1*/ [ 4, 0,11, 7, 3,19,10,19, 8],
/*2*/ [14, 7, 0, 7,13,19,18,20, 5],
/*3*/ [17,17, 7, 0,11, 7,17, 0,10],
/*4*/ [20,10, 2,18, 0,15, 8, 6,18],
/*5*/ [ 4, 9,12, 1,17, 0, 0,13,18],
/*6*/ [12,15,12,19,18,19, 0, 6,17],
/*7*/ [14, 1,17,20,11,20, 6, 0, 4],
/*8*/ [19, 3,19,12, 8,18,17,13, 0]
];

% Decision variables: flow on each directed arc (i,j)
array[V, V] of var 0..max(cap): f;

% Capacity constraints (also forces f[i,i]=0 since cap[i,i]=0)
constraint forall(i, j in V) (
  f[i,j] <= cap[i,j]
);

% Flow conservation on intermediate nodes
constraint forall(v in V where v != s /\ v != t) (
  sum(i in V)(f[i,v]) = sum(j in V)(f[v,j])
);

% Objective: maximize net flow out of source (equals net flow into sink)
var 0..sum(j in V)(cap[s,j]): F;
constraint F = sum(j in V)(f[s,j]) - sum(i in V)(f[i,s]);

solve maximize F;

output [
  "Max flow (thousand gallons per hour) = ", show(F), "\n",
  "Flow matrix f[i,j] (i=0..8 rows):\n",
  concat([ concat([ if j=0 then "[" else "" endif
                   ++ show(f[i,j])
                   ++ if j=8 then "]\n" else ", " endif
                 | j in V ])
         | i in V ])
];