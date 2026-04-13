% Parameters
int: N = 9;
set of int: V = 0..N-1;
int: s = 0;
int: t = 8;

array[V, V] of int: cap =
array2d(V, V,
[
  0,  9,  7, 18,  0,  0,  7,  0,  2,
 15,  0, 11,  5, 20, 15, 18,  9, 15,
  3,  8,  0, 10, 16, 18,  8,  0, 20,
 13,  3,  7,  0, 20, 13, 16,  6, 20,
  7, 20,  2,  4,  0,  9,  3, 14,  2,
 17, 10,  5,  1,  4,  0,  4,  3, 20,
  0, 20, 10, 10, 15,  5,  0,  1, 10,
 10,  3,  9,  4,  3, 13, 18,  0, 20,
  2, 12, 10,  5, 15, 14,  0, 10,  0
]);

int: U = sum(i in V, j in V)(cap[i,j]);

% Variables
array[V, V] of var 0..U: f;
var 0..U: maxflow;

% Constraints
constraint
  forall(i in V, j in V) (
    f[i,j] <= cap[i,j]
  );

constraint
  forall(k in V where k != s /\ k != t) (
    sum(i in V)(f[i,k]) = sum(j in V)(f[k,j])
  );

constraint
  maxflow = sum(j in V)(f[s,j]) - sum(i in V)(f[i,s]);

constraint
  maxflow = sum(i in V)(f[i,t]) - sum(j in V)(f[t,j]);

% Objective
solve maximize maxflow;