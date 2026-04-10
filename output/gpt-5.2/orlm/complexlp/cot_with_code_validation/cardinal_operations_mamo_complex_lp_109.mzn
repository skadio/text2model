% Max flow from s to t in a directed capacitated network

int: N = 9;
set of int: V = 0..N-1;
int: s = 0;
int: t = 8;

array[V, V] of int: cap =
[
| 0,14,20, 7, 9, 1, 4, 8,19
| 3, 0,15,12,17, 0,15, 3, 3
|11, 8, 0, 1,19,16, 5, 1, 2
|13,13, 2, 0,16,20,16,17, 3
| 6,15, 7, 3, 0,18, 1, 3, 9
|15,20, 8, 4, 6, 0, 3, 1, 4
| 5,15,19, 4,15,12, 0, 3, 8
| 7,14,13,12, 9,10, 3, 0, 4
| 3,12, 6, 6, 1,11, 6, 1, 0
];

int: U = max([cap[i,j] | i in V, j in V]);
int: OUTS = sum(j in V)(cap[s,j]);

% Flow on each arc (i,j)
array[V, V] of var 0..U: f;

% Total flow value
var 0..OUTS: maxflow;

% Capacity constraints (and implicitly 0 flow where cap=0)
constraint forall(i in V, j in V) (
  f[i,j] <= cap[i,j]
);

% Flow conservation for intermediate nodes
constraint forall(v in V where v != s /\ v != t) (
  sum(i in V)(f[i,v]) = sum(j in V)(f[v,j])
);

% Define maxflow using only one equation to avoid duplicated definition
constraint maxflow = sum(j in V)(f[s,j]) - sum(i in V)(f[i,s]);

solve maximize maxflow;

output [
  "maxflow = ", show(maxflow), "\n"
];