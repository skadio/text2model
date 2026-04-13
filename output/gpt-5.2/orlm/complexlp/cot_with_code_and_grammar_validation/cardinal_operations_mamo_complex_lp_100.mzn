% Parameters
int: N = 9;
set of int: V = 0..N-1;

int: s = 0;
int: t = 8;

array[V, V] of int: cap =
array2d(V, V,
[
  0, 15,  1,  9, 18, 12, 18,  6, 17,
 14,  0, 13, 11, 14, 10, 15,  4, 15,
  3,  0,  0,  2, 14, 16,  7, 12,  4,
  5, 20,  0,  0,  9,  1, 12,  1, 20,
 11, 18, 12,  3,  0,  4, 16, 15,  2,
 13,  8,  8,  6,  4,  0,  8, 10, 11,
 12,  1,  3,  4, 11,  8,  0, 10, 19,
 18,  3,  9,  5,  9, 17, 10,  0, 13,
  9,  8, 12,  2,  5,  2, 16,  5,  0
]);

int: U = sum(i in V)(cap[s,i]); % upper bound on max flow

% Variables
array[V, V] of var 0..U: f;
var 0..U: F;

% Constraints
constraint forall(i in V, j in V) (
  f[i,j] <= cap[i,j]
);

constraint forall(i in V where i != s /\ i != t) (
  sum(j in V)(f[j,i]) = sum(j in V)(f[i,j])
);

constraint F = sum(j in V)(f[s,j]) - sum(j in V)(f[j,s]);
constraint F = sum(j in V)(f[j,t]) - sum(j in V)(f[t,j]);

% Objective
solve maximize F;