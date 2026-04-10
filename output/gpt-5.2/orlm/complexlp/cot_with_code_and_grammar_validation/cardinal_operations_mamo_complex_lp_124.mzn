% Parameters
int: N = 9;
set of int: V = 0..N-1;
int: s = 0;
int: t = 8;

array[V, V] of int: cap =
array2d(V, V, [
  0,  1, 16,  8, 18,  4,  0,  8,  5,
  15, 0, 11,  8, 13,  2,  1,  7,  6,
  15, 4,  0,  3,  1, 13, 13, 11,  9,
  4, 16,  8,  0, 12, 18, 19,  8, 11,
  4, 19,  3,  2,  0,  6,  1, 13, 14,
  6, 19, 15, 10, 16,  0, 17, 15, 17,
  13, 7, 13,  4, 14,  3,  0,  8,  8,
  10, 6, 19,  1, 12,  6,  9,  0, 14,
  0,  0,  0,  0,  0,  0,  0,  0,  0
]);

int: U = max([cap[i,j] | i in V, j in V]);

% Variables
array[V, V] of var 0..U: f;
var 0..(sum(j in V)(cap[s,j])): F;

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
  F = sum(j in V)(f[s,j]) - sum(i in V)(f[i,s]);

constraint
  F = sum(i in V)(f[i,t]) - sum(j in V)(f[t,j]);

% Objective
solve maximize F;