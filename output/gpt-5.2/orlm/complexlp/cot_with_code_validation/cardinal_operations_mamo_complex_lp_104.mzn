% Max flow from source s to sink t in a directed capacitated graph

int: N = 9;
set of int: V = 0..N-1;
int: s = 0;
int: t = 8;

array[V, V] of int: cap =
[
|  0,  6,  1, 14, 20,  6, 13, 13, 15
|  2,  0,  5,  5, 13,  5, 12,  9, 15
| 15,  0,  0,  8, 16,  9, 19, 15,  6
| 13,  8,  0,  0, 14, 12,  9,  1,  2
|  4, 14, 19, 16,  0, 14, 11, 11,  2
| 19, 18,  5, 20,  9,  0, 11,  5,  7
| 11, 14, 20, 17, 11, 13,  0, 11, 16
|  6,  2, 17,  0, 10, 13, 17,  0,  9
|  8,  9,  7, 18, 12, 13,  5,  9,  0
|];

int: OUT_S = sum(j in V)(cap[s,j]);
int: max_cap = max([cap[i,j] | i in V, j in V]);

array[V, V] of var 0..max_cap: f;
var 0..OUT_S: flow_value;

% Capacity constraints (only define flow on existing arcs)
constraint forall(i in V, j in V) (
  f[i,j] <= cap[i,j]
);

% Flow conservation (avoid if-then-else inside sum equality to prevent backend issues)
constraint sum(j in V)(f[s,j]) - sum(j in V)(f[j,s]) = flow_value;
constraint sum(j in V)(f[t,j]) - sum(j in V)(f[j,t]) = -flow_value;
constraint forall(i in V where i != s /\ i != t) (
  sum(j in V)(f[i,j]) - sum(j in V)(f[j,i]) = 0
);

solve maximize flow_value;

output [
  "max_flow=", show(flow_value), "\n"
];