% Parameters
int: N = 9;
set of int: V = 0..N-1;
int: s = 0;
int: t = 8;

array[V, V] of int: cap =
array2d(V, V,
[
  0,  6,  1, 14, 20,  6, 13, 13, 15,
  2,  0,  5,  5, 13,  5, 12,  9, 15,
 15,  0,  0,  8, 16,  9, 19, 15,  6,
 13,  8,  0,  0, 14, 12,  9,  1,  2,
  4, 14, 19, 16,  0, 14, 11, 11,  2,
 19, 18,  5, 20,  9,  0, 11,  5,  7,
 11, 14, 20, 17, 11, 13,  0, 11, 16,
  6,  2, 17,  0, 10, 13, 17,  0,  9,
  8,  9,  7, 18, 12, 13,  5,  9,  0
]);

int: U = max([cap[i,j] | i in V, j in V]);

% Variables
array[V, V] of var 0..U: f;          % flow on each directed arc
var 0..sum(j in V)(cap[s,j]): F;      % total flow value from s to t

% Constraints
constraint
  forall(i in V, j in V) (
    f[i,j] <= cap[i,j]
  );

constraint
  forall(i in V where i != s /\ i != t) (
    sum(j in V)(f[i,j]) = sum(j in V)(f[j,i])
  );

constraint
  F = sum(j in V)(f[s,j]) - sum(j in V)(f[j,s]);

constraint
  F = sum(j in V)(f[j,t]) - sum(j in V)(f[t,j]);

% Objective
solve maximize F;