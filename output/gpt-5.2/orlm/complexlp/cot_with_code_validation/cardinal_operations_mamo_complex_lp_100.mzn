% Parameters
int: N = 9;
set of int: V = 0..N-1;

int: s = 0;
int: t = 8;

array[V, V] of int: cap =
array2d(V, V, [
  % from 0
  0, 15,  1,  9, 18, 12, 18,  6, 17,
  % from 1
 14,  0, 13, 11, 14, 10, 15,  4, 15,
  % from 2
  3,  0,  0,  2, 14, 16,  7, 12,  4,
  % from 3
  5, 20,  0,  0,  9,  1, 12,  1, 20,
  % from 4
 11, 18, 12,  3,  0,  4, 16, 15,  2,
  % from 5
 13,  8,  8,  6,  4,  0,  8, 10, 11,
  % from 6
 12,  1,  3,  4, 11,  8,  0, 10, 19,
  % from 7
 18,  3,  9,  5,  9, 17, 10,  0, 13,
  % from 8
  9,  8, 12,  2,  5,  2, 16,  5,  0
]);

int: maxCap = max([cap[i,j] | i in V, j in V]);
int: U = (N-1) * maxCap;

% Variables
array[V, V] of var 0..maxCap: f;
var 0..U: F;

% Constraints
constraint forall(i in V, j in V) (
  f[i,j] <= cap[i,j]
);

constraint forall(k in V where k != s /\ k != t) (
  sum(j in V)(f[k,j]) = sum(i in V)(f[i,k])
);

constraint F = sum(j in V)(f[s,j]) - sum(i in V)(f[i,s]);
constraint F = sum(i in V)(f[i,t]) - sum(j in V)(f[t,j]);

% Objective
solve maximize F;