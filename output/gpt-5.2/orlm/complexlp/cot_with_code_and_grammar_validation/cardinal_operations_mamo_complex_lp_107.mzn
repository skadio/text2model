% Parameters
int: N = 7;
set of int: V = 0..N-1;

int: s = 0;
int: t = 6;

array[V, V] of int: cap =
array2d(V, V,
[
  0, 17,  3, 20, 11, 11,  3,
 11,  0, 12, 18,  5,  6,  4,
  7,  2,  0, 15, 13, 20, 18,
  7,  4,  2,  0,  2, 15,  3,
 19, 12, 16,  4,  0, 19,  4,
 13, 20, 10, 14, 15,  0,  1,
  3,  3,  6, 20,  9, 10,  0
]);

int: UB = sum(i in V)(cap[s,i]);

% Variables
array[V, V] of var 0..UB: f;
var 0..UB: flow;

% Constraints
constraint forall(i in V, j in V) (
  f[i,j] <= cap[i,j]
);

constraint forall(i in V)(
  (i == s \/ i == t) \/
  (sum(j in V)(f[j,i]) = sum(j in V)(f[i,j]))
);

constraint flow = sum(j in V)(f[s,j]) - sum(j in V)(f[j,s]);
constraint flow = sum(j in V)(f[j,t]) - sum(j in V)(f[t,j]);

% Objective
solve maximize flow;