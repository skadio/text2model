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

int: max_cap = max([cap[i,j] | i in V, j in V]);

% Variables
array[V, V] of var 0..max_cap: f;
var 0..(N * max_cap): flow;

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
  forall(k in V where k != s /\ k != t) (
    sum(j in V)(f[k,j]) = sum(i in V)(f[i,k])
  );

constraint
  flow = sum(j in V)(f[s,j]) - sum(i in V)(f[i,s]);

constraint
  flow = sum(i in V)(f[i,t]) - sum(j in V)(f[t,j]);

% Objective
solve maximize flow;