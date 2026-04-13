% Parameters
int: N = 7;
set of int: V = 0..N-1;

int: s = 0;
int: t = 6;

array[V, V] of int: cap =
array2d(V, V,
[
  0, 18,  2, 10, 17,  0, 12,
 14,  0,  3,  1, 19, 18,  2,
 17,  5,  0, 15, 15, 19,  0,
 14, 17,  0,  0, 19,  9, 16,
  2, 13, 15, 12,  0, 20,  5,
  9, 16,  4, 15, 15,  0, 11,
  8, 10, 19, 19, 17, 16,  0
]);

int: totalCap = sum(i in V, j in V)(cap[i,j]);

% Variables
array[V, V] of var 0..totalCap: f;
var 0..totalCap: maxflow;

% Constraints
constraint forall(i in V, j in V) (
  f[i,j] <= cap[i,j]
);

constraint forall(i in V where i != s /\ i != t) (
  sum(j in V)(f[j,i]) = sum(j in V)(f[i,j])
);

constraint maxflow = sum(j in V)(f[s,j]) - sum(j in V)(f[j,s]);

constraint maxflow = sum(j in V)(f[j,t]) - sum(j in V)(f[t,j]);

% Objective
solve maximize maxflow;