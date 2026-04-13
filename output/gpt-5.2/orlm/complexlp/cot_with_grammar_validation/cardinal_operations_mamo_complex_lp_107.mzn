% Parameters
int: N = 7;
set of int: V = 0..N-1;
int: s = 0;
int: t = 6;

array[V, V] of int: cap =
array2d(V, V, [
  0, 17,  3, 20, 11, 11,  3,
 11,  0, 12, 18,  5,  6,  4,
  7,  2,  0, 15, 13, 20, 18,
  7,  4,  2,  0,  2, 15,  3,
 19, 12, 16,  4,  0, 19,  4,
 13, 20, 10, 14, 15,  0,  1,
  3,  3,  6, 20,  9, 10,  0
]);

% Variables
int: U = sum(i in V, j in V)(cap[i,j]);

array[V, V] of var 0..U: f;
var 0..U: maxflow;

% Constraints
constraint forall(i in V, j in V)(
  f[i,j] <= cap[i,j]
);

constraint forall(k in V where k != s /\ k != t)(
  sum(i in V)(f[i,k]) = sum(j in V)(f[k,j])
);

constraint maxflow = sum(j in V)(f[s,j]) - sum(i in V)(f[i,s]);

constraint maxflow = sum(i in V)(f[i,t]) - sum(j in V)(f[t,j]);

% Objective
solve maximize maxflow;