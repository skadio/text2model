% Parameters
int: N = 8;
set of int: V = 0..N-1;
int: s = 0;
int: t = 7;

array[V, V] of int: cap =
array2d(V, V,
[
  0, 15, 19,  4,  4,  3, 20, 17,
  8,  0,  6,  5, 20,  3, 15,  1,
 11, 13,  0, 16, 15,  7, 10, 13,
 17, 20,  6,  0, 11,  3,  2,  0,
 10, 15,  5,  0,  0,  9,  9, 15,
  9, 17,  5,  1,  9,  0, 20,  2,
  4, 16, 10,  2,  1,  6,  0,  4,
  0,  0,  0,  0,  0,  0,  0,  0
]);

int: cap_max = max([cap[i,j] | i in V, j in V]);

% Variables
array[V, V] of var 0..cap_max: f;
var 0..(cap_max * N): maxflow;

% Constraints
constraint
  forall(i in V, j in V) (
    f[i,j] <= cap[i,j]
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