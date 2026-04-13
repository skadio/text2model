% Parameters
int: N = 7;
set of int: V = 0..N-1;

int: s = 0;
int: t = 6;

array[V, V] of int: cap =
array2d(V, V,
[
  0, 15,  2, 16,  3,  5,  3,
  7,  0,  0,  0, 19, 15, 16,
 11, 14,  0, 14,  8, 11,  6,
 17, 11, 11,  0, 11, 16, 19,
 10,  4, 17, 20,  0, 12, 17,
  3,  0,  4,  5, 20,  0,  4,
 15,  2, 15, 18, 17,  7,  0
]);

int: max_cap = sum(i,j in V)(cap[i,j]);

% Variables
array[V, V] of var 0..max_cap: f;
var 0..max_cap: F;

% Constraints
constraint forall(i,j in V)(f[i,j] <= cap[i,j]);

constraint
  forall(v in V where v != s /\ v != t)(
    sum(i in V)(f[i,v]) = sum(j in V)(f[v,j])
  );

constraint F = sum(j in V)(f[s,j]) - sum(i in V)(f[i,s]);
constraint F = sum(i in V)(f[i,t]) - sum(j in V)(f[t,j]);

% Objective
solve maximize F;