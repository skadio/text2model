% Parameters
int: N = 7;
set of int: V = 0..N-1;
int: s = 0;
int: t = 6;

array[V, V] of int: cap =
array2d(V, V,
[
  0, 18000, 11000, 15000,  2000,  4000, 20000,
  4000,     0,  6000,  5000, 19000, 15000,     0,
 15000, 10000,     0,  7000,     0,  7000,  5000,
 14000,  5000,  3000,     0, 10000, 15000, 19000,
  2000, 11000,  1000, 10000,     0, 14000,  6000,
 10000, 14000,  6000,  5000,  3000,     0, 18000,
  8000,  1000, 11000,  8000,  6000, 20000,     0
]);

int: U = max([cap[i,j] | i in V, j in V]);

% Variables
array[V, V] of var 0..U: f;
var 0..(N*U): maxflow;

% Constraints
constraint
  forall(i in V, j in V) (
    f[i,j] <= cap[i,j]
  );

constraint
  forall(k in V where k != s /\ k != t) (
    sum(j in V)(f[k,j]) = sum(i in V)(f[i,k])
  );

constraint
  maxflow = sum(j in V)(f[s,j]) - sum(i in V)(f[i,s]);

constraint
  maxflow = sum(i in V)(f[i,t]) - sum(j in V)(f[t,j]);

% Objective
solve maximize maxflow;