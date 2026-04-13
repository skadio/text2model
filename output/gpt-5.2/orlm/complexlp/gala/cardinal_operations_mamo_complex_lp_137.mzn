include "globals.mzn";

% Max flow from source 0 to sink 8 in a directed capacitated network with 9 nodes (0..8).
int: N = 9;
set of int: V = 0..N-1;
int: s = 0;
int: t = 8;

array[V, V] of int: cap =
[
% to:   0  1  2  3  4  5  6  7  8
/*0*/ [ 0, 9, 7,18, 0, 0, 7, 0, 2],
/*1*/ [15, 0,11, 5,20,15,18, 9,15],
/*2*/ [ 3, 8, 0,10,16,18, 8, 0,20],
/*3*/ [13, 3, 7, 0,20,13,16, 6,20],
/*4*/ [ 7,20, 2, 4, 0, 9, 3,14, 2],
/*5*/ [17,10, 5, 1, 4, 0, 4, 3,20],
/*6*/ [ 0,20,10,10,15, 5, 0, 1,10],
/*7*/ [10, 3, 9, 4, 3,13,18, 0,20],
/*8*/ [ 2,12,10, 5,15,14, 0,10, 0]
];

% Decision variables: flow on each directed arc
int: MAXCAP = max([cap[i,j] | i in V, j in V]);
array[V, V] of var 0..MAXCAP: f;

% Capacity constraints (and force 0 flow where no arc)
constraint forall(i in V, j in V) (
  f[i,j] <= cap[i,j]
);

% Flow conservation at intermediate nodes
constraint forall(v in V where v != s /\ v != t) (
  sum(j in V)(f[v,j]) = sum(i in V)(f[i,v])
);

% Define objective value as net outflow from source (equivalently net inflow to sink)
var 0..(N*MAXCAP): maxFlow;
constraint maxFlow = sum(j in V)(f[s,j]) - sum(i in V)(f[i,s]);
constraint maxFlow = sum(i in V)(f[i,t]) - sum(j in V)(f[t,j]);

solve maximize maxFlow;

output [
  "Maximum flow (thousand gallons per hour) = ", show(maxFlow), "\n",
  "Flow matrix f[i,j]:\n",
  concat([ concat([ if j==0 then "" else " " endif ++ show(f[i,j]) | j in V]) ++ "\n" | i in V ])
];