include "globals.mzn";

% Max-flow from source 0 to sink 5 on a directed graph with capacities (MW).
int: n = 6;
set of int: V = 0..n-1;
int: s = 0;
int: t = 5;

array[V, V] of int: cap =
[|  0,  4, 12, 19, 13, 11
 | 20,  0, 13,  9, 10,  0
 | 14,  8,  0,  5, 13, 11
 |  5, 15, 18,  0,  6,  7
 |  8, 17, 20, 14,  0,  9
 |  9, 19, 19, 11,  4,  0 |];

% Decision variables: flow on each directed arc
int: U = max([cap[i,j] | i in V, j in V]); % upper bound per arc
array[V, V] of var 0..U: f;

% Capacity constraints and no-self-flow
constraint forall(i in V, j in V) (
  f[i,j] <= cap[i,j]
);
constraint forall(i in V) ( f[i,i] = 0 );

% Flow conservation at intermediate nodes
constraint forall(v in V where v != s /\ v != t) (
  sum(i in V)(f[i,v]) = sum(j in V)(f[v,j])
);

% Objective: maximize net flow out of source (equals net flow into sink)
var 0..sum(j in V)(cap[s,j]): maxflow;
constraint maxflow = sum(j in V)(f[s,j]) - sum(i in V)(f[i,s]);

solve maximize maxflow;

output [
  "Maximum flow (MW) = ", show(maxflow), "\n",
  "Flow matrix f[i,j] (MW):\n", show(f), "\n"
];