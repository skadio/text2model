% Parameters
int: N = 8;
set of int: V = 0..N-1;
int: s = 0;
int: t = 7;

array[V, V] of int: cap =
array2d(V, V,
[
  0,  3,  7,  2, 18, 18, 14, 10,
  1,  0, 10, 16, 14,  0,  6, 10,
  4,  0,  0,  7,  2,  2,  6, 10,
  2,  3,  7,  0, 20,  8,  6, 10,
  1, 20,  4,  8,  0, 13,  8,  1,
 16,  9, 17, 17, 11,  0,  7,  8,
  3,  7, 14,  1, 20,  5,  0, 13,
  3,  6,  5,  1, 14, 20,  9,  0
]);

int: UB = sum(i in V)(cap[s,i]);

% Variables
array[V, V] of var 0..UB: f;
var 0..UB: flow;

% Constraints
constraint forall(i in V, j in V) (
  f[i,j] <= cap[i,j]
);

constraint forall(v in V where v != s /\ v != t) (
  sum(i in V)(f[i,v]) = sum(j in V)(f[v,j])
);

constraint flow = sum(j in V)(f[s,j]) - sum(i in V)(f[i,s]);
constraint flow = sum(i in V)(f[i,t]) - sum(j in V)(f[t,j]);

% Objective
solve maximize flow;