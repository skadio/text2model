% Parameters
int: N = 6;
set of int: V = 0..N-1;

int: s = 0;
int: t = 5;

array[V, V] of int: cap =
array2d(V, V,
[
  0, 14, 15, 13,  0,  4,
 10,  0,  7, 18,  9,  5,
 11,  0,  0,  7, 13,  6,
  7, 11, 18,  0, 17,  2,
 19,  8, 15, 15,  0,  5,
 10, 19, 17,  2,  3,  0
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
  forall(i in V, j in V where cap[i,j] = 0) (
    f[i,j] = 0
  );

constraint
  forall(v in V where v != s /\ v != t) (
    sum(j in V)(f[v,j]) = sum(i in V)(f[i,v])
  );

constraint
  maxflow = sum(j in V)(f[s,j]) - sum(i in V)(f[i,s]);

constraint
  maxflow = sum(i in V)(f[i,t]) - sum(j in V)(f[t,j]);

% Objective
solve maximize maxflow;