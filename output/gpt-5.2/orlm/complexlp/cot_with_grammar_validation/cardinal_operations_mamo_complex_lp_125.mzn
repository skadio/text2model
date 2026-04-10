% Parameters
int: N = 9;
set of int: V = 0..N-1;

int: s = 0;
int: t = 8;

array[V, V] of int: cap =
array2d(V, V,
[
  0,  5,  2,  7, 17,  4,  1,  2, 13,
 12,  0, 15, 18,  8,  9,  8,  1, 15,
 17, 16,  0, 20, 17, 13,  2, 19,  6,
  5,  9, 14,  0, 10, 18, 20,  9, 18,
 12, 14,  7,  6,  0,  6, 17,  4,  9,
 12, 11, 10,  1, 13,  0, 14, 12, 14,
 13,  7,  3,  9,  1, 14,  0,  7, 16,
 18, 15,  8,  0, 12, 13,  5,  0, 17,
  3, 11, 15, 14,  0,  4, 18, 16,  0
]);

int: U = sum(i in V, j in V)(cap[i,j]);

% Variables
array[V, V] of var 0..U: f;
array[V] of var 0..U: outflow;
array[V] of var 0..U: inflow;
var 0..U: maxflow;

% Constraints
constraint forall(i in V, j in V) ( f[i,j] <= cap[i,j] );

constraint forall(i in V)(
  outflow[i] = sum(j in V)(f[i,j])
);

constraint forall(i in V)(
  inflow[i] = sum(j in V)(f[j,i])
);

constraint forall(v in V where v != s /\ v != t)(
  outflow[v] = inflow[v]
);

constraint maxflow = outflow[s] - inflow[s];
constraint maxflow = inflow[t] - outflow[t];

% Objective
solve maximize maxflow;

output ["maxflow = ", show(maxflow), "\n"];