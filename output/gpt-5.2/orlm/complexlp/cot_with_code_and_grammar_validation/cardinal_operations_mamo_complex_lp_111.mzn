% Parameters
int: N = 8;
set of int: V = 0..N-1;

int: s = 0;
int: t = 7;

array[V, V] of int: cap =
array2d(V, V,
[
  0, 19,  4,  1,  9, 13,  8, 20,
 10,  0, 12, 12,  8, 12,  7,  7,
 13, 11,  0,  8,  4,  1,  2,  3,
  4, 12, 13,  0, 18,  6, 19,  8,
  9, 16,  2,  0,  0, 14, 18,  7,
 10, 11,  7, 11, 16,  0, 16,  5,
 14, 11,  9, 11,  3, 17,  0, 19,
 12, 20,  5, 11, 10,  4,  6,  0
]);

int: UB = sum(i in V)(cap[s,i]);

% Variables
array[V, V] of var 0..UB: f;
var 0..UB: F;

% Constraints
constraint
  forall(i in V, j in V)(
    f[i,j] <= cap[i,j]
  );

constraint
  forall(i in V)(f[i,i] = 0);

constraint
  forall(v in V where v != s /\ v != t)(
    sum(i in V)(f[i,v]) = sum(j in V)(f[v,j])
  );

constraint
  F = sum(j in V)(f[s,j]) - sum(i in V)(f[i,s]);

constraint
  F = sum(i in V)(f[i,t]) - sum(j in V)(f[t,j]);

% Objective
solve maximize F;