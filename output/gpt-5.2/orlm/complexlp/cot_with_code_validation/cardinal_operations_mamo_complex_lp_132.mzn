% Max flow from source s to sink t in a directed capacitated graph

int: N = 8;
set of int: V = 0..N-1;

int: s = 0;
int: t = 7;

array[V, V] of int: cap =
[
| 0,  2,  1,  1,  8, 17,  6,  7 |
| 4,  0, 14, 14, 13, 19,  4, 19 |
| 6, 16,  0,  3, 10,  7, 18, 10 |
|19,  4, 15,  0,  6,  1, 17,  9 |
|12, 15,  3, 14,  0, 18, 20, 14 |
|20,  5, 19,  9, 20,  0, 10,  6 |
| 9, 14, 12, 16, 19,  3,  0, 10 |
|20, 16,  6, 16,  8, 16,  4,  0 |
];

int: maxCap = max([cap[i,j] | i in V, j in V]);
int: maxF = sum(j in V)(cap[s,j]);

% Flow variables on arcs
array[V, V] of var 0..maxCap: f;

% Total flow value
var 0..maxF: F;

% Capacity and no self-loop flow
constraint forall(i in V, j in V) ( f[i,j] <= cap[i,j] );
constraint forall(i in V) ( f[i,i] = 0 );

% Flow conservation for intermediate nodes
constraint forall(v in V where v != s /\ v != t) (
  sum(i in V)(f[i,v]) = sum(j in V)(f[v,j])
);

% Define objective flow as net outflow from source (equivalently, net inflow to sink)
constraint F = sum(j in V)(f[s,j]) - sum(i in V)(f[i,s]);

solve maximize F;

output ["Max flow = ", show(F), "\n"];