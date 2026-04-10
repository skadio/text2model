% Parameters
int: N = 6;
set of int: V = 0..N-1;
int: s = 0;
int: t = 5;

array[V, V] of int: cap =
array2d(V, V,
[
  0,  7,  8,  1,  2,  4,
 15,  0, 16,  0,  9, 13,
  9,  1,  0,  9, 13, 13,
 10, 11, 19,  0,  1, 12,
 15, 16,  7, 11,  0, 19,
 10, 12, 12, 12, 20,  0
]);

int: U = max([cap[i,j] | i in V, j in V]);

% Variables
array[V, V] of var 0..U: f;
var 0..(sum(j in V)(cap[s,j])): maxflow;

% Constraints
constraint
  forall(i in V, j in V) (
    f[i,j] <= cap[i,j]
  );

constraint
  forall(v in V where v != s /\ v != t) (
    sum(i in V)(f[i,v]) = sum(j in V)(f[v,j])
  );

constraint
  maxflow = sum(j in V)(f[s,j]) - sum(i in V)(f[i,s]);

constraint
  maxflow = sum(i in V)(f[i,t]) - sum(j in V)(f[t,j]);

% Objective
solve maximize maxflow;