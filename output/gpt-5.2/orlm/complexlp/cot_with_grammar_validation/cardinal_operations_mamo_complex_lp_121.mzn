% Parameters
int: N = 8;
set of int: V = 0..N-1;
int: s = 0;
int: t = 7;

array[V, V] of int: cap =
array2d(V, V, [
  % from 0
   0,  6, 16,  5,  6, 11,  6,  4,
  % from 1
   0,  0,  8, 10,  6,  3,  6, 14,
  % from 2
   0,  6,  0, 20,  7, 16, 13, 14,
  % from 3
   0, 11, 19,  0, 18,  5,  0,  8,
  % from 4
   0,  1, 14, 18,  0, 12,  4,  7,
  % from 5
   0, 16,  3, 20,  7,  0, 15,  6,
  % from 6
   0, 11,  4, 19,  7,  6,  0, 17,
  % from 7
   0,  5,  8, 17,  2,  5,  4,  0
]);

int: maxCap = max([cap[i,j] | i in V, j in V]);

% Variables
array[V, V] of var 0..maxCap: f;
var 0..(sum(j in V)(cap[s,j])): F;

% Constraints
constraint forall(i in V, j in V) ( f[i,j] <= cap[i,j] );

constraint forall(i in V where i != s /\ i != t) (
  sum(j in V)(f[i,j]) = sum(j in V)(f[j,i])
);

constraint F = sum(j in V)(f[s,j]) - sum(j in V)(f[j,s]);
constraint F = sum(j in V)(f[j,t]) - sum(j in V)(f[t,j]);

% Objective
solve maximize F;