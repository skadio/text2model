% Max Flow from Hub 0 (source) to Hub 7 (sink) with embedded data

int: N = 8;
set of int: V = 0..N-1;
int: s = 0;
int: t = 7;

array[V, V] of int: cap =
[
|  0, 15, 19,  4,  4,  3, 20, 17 |
|  8,  0,  6,  5, 20,  3, 15,  1 |
| 11, 13,  0, 16, 15,  7, 10, 13 |
| 17, 20,  6,  0, 11,  3,  2,  0 |
| 10, 15,  5,  0,  0,  9,  9, 15 |
|  9, 17,  5,  1,  9,  0, 20,  2 |
|  4, 16, 10,  2,  1,  6,  0,  4 |
|  0,  0,  0,  0,  0,  0,  0,  0 |
];

int: U = sum(i in V, j in V)(cap[i,j]);

array[V, V] of var 0..U: f;

% Capacity constraints; enforce no flow on non-arcs (cap=0)
constraint
  forall(i in V, j in V) (
    f[i,j] <= cap[i,j]
  );

% Flow conservation for intermediate nodes
constraint
  forall(k in V where k != s /\ k != t) (
    sum(i in V)(f[i,k]) = sum(j in V)(f[k,j])
  );

% Define objective value as net outflow from source (equals net inflow to sink)
var 0..U: maxflow;
constraint maxflow = sum(j in V)(f[s,j]) - sum(i in V)(f[i,s]);

solve maximize maxflow;

output [
  "Maximum flow from hub ", show(s), " to hub ", show(t), ": ", show(maxflow), "\n"
];