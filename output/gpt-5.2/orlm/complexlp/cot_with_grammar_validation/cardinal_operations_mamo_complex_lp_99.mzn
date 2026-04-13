% Parameters
int: N = 6;
set of int: V = 0..N-1;

int: s = 0;
int: t = 5;

array[V, V] of int: cap =
array2d(V, V,
[
  0, 14,  9,  8,  7,  8,
  4,  0,  9, 10,  0, 12,
  4, 12,  0, 13, 20, 16,
 10,  8, 12,  0,  0, 18,
  3, 13, 11, 20,  0,  2,
 17,  4,  8,  2, 12,  0
]);

int: U = sum(i in V, j in V)(cap[i,j]);

% Variables
array[V, V] of var 0..U: f;
var 0..U: maxflow;

% Constraints
constraint forall(i in V, j in V) (f[i,j] <= cap[i,j]);

constraint forall(v in V where v != s /\ v != t)(
  sum(i in V)(f[i,v]) = sum(j in V)(f[v,j])
);

constraint maxflow = sum(j in V)(f[s,j]) - sum(i in V)(f[i,s]);
constraint maxflow = sum(i in V)(f[i,t]) - sum(j in V)(f[t,j]);

% Objective
solve maximize maxflow;