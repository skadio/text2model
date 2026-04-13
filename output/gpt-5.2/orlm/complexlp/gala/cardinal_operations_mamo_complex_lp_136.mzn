include "globals.mzn";

% Max-flow from source s=0 to sink t=6 on a directed capacitated graph of 7 hubs.
int: n = 7;
set of int: V = 0..n-1;
int: s = 0;
int: t = 6;

% Capacity matrix cap[i,j] (0 means no arc)
array[V, V] of int: cap =
[
| 0, 15,  2, 16,  3,  5,  3 |
| 7,  0,  0,  0, 19, 15, 16 |
|11, 14,  0, 14,  8, 11,  6 |
|17, 11, 11,  0, 11, 16, 19 |
|10,  4, 17, 20,  0, 12, 17 |
| 3,  0,  4,  5, 20,  0,  4 |
|15,  2, 15, 18, 17,  7,  0 |
];

% Decision variables: flow on each directed arc (allow 0 if no arc)
array[V, V] of var 0..20: f;

% Respect capacities (and force 0 where cap = 0)
constraint forall(i in V, j in V) (
  f[i,j] <= cap[i,j]
);

% Flow conservation at intermediate nodes
constraint forall(k in V where k != s /\ k != t) (
  sum(j in V)(f[k,j]) = sum(i in V)(f[i,k])
);

% Maximize total flow out of source (equivalently into sink by conservation)
var 0..200: maxflow = sum(j in V)(f[s,j]);
constraint maxflow = sum(i in V)(f[i,t]);

solve maximize maxflow;

output [
  "Maximum vehicles per hour from hub ", show(s), " to hub ", show(t), " = ", show(maxflow), "\n",
  "Flow matrix f[i,j]:\n",
  show(f), "\n"
];