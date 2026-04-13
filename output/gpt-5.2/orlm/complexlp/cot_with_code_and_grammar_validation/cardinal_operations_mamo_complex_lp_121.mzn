% Parameters
int: N = 8;
set of int: V = 0..N-1;
int: s = 0;
int: t = 7;

array[V, V] of int: cap =
array2d(V, V, [
  0,  6, 16,  5,  6, 11,  6,  4,
  0,  0,  8, 10,  6,  3,  6, 14,
  0,  6,  0, 20,  7, 16, 13, 14,
  0, 11, 19,  0, 18,  5,  0,  8,
  0,  1, 14, 18,  0, 12,  4,  7,
  0, 16,  3, 20,  7,  0, 15,  6,
  0, 11,  4, 19,  7,  6,  0, 17,
  0,  5,  8, 17,  2,  5,  4,  0
]);

int: U = sum(i in V, j in V)(cap[i,j]);

% Variables
array[V, V] of var 0..U: f;
var 0..U: maxflow;

% Constraints
constraint forall(i in V, j in V) (
  f[i,j] <= cap[i,j]
);

constraint forall(v in V where v != s /\ v != t) (
  sum(i in V)(f[i,v]) = sum(j in V)(f[v,j])
);

constraint maxflow = sum(j in V)(f[s,j]) - sum(i in V)(f[i,s]);
constraint maxflow = sum(i in V)(f[i,t]) - sum(j in V)(f[t,j]);

% Objective
solve maximize maxflow;