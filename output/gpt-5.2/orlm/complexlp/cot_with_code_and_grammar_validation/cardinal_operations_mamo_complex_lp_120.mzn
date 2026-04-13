% Parameters
int: N = 9;
set of int: V = 0..N-1;
int: s = 0;
int: t = 8;

array[V, V] of int: cap =
array2d(V, V,
[
  0,  4,  7, 15,  4,  7,  2, 10, 12,
  0,  0, 17,  2,  5,  1, 10, 14,  5,
  0,  7,  0, 17,  9, 13, 10,  7,  5,
  0, 16,  4,  0, 11,  9, 12, 18, 12,
  0,  3,  0, 18,  0,  5,  2,  0, 19,
  0, 15,  7, 20, 20,  0, 20, 12,  9,
  0,  8, 14, 13,  1, 17,  0, 10, 19,
  0,  5,  5, 16,  5,  7,  3,  0, 19,
  0, 19, 18,  0,  4,  7,  1, 20,  0
]);

int: maxCap = max([cap[i,j] | i in V, j in V]);

% Variables
array[V, V] of var 0..maxCap: f;
var 0..sum([cap[s,j] | j in V]): totalFlow;

% Constraints
constraint forall(i in V, j in V) (
  f[i,j] <= cap[i,j]
);

constraint totalFlow = sum(j in V)(f[s,j]) - sum(j in V)(f[j,s]);

constraint forall(v in V where v != s /\ v != t) (
  sum(j in V)(f[v,j]) - sum(i in V)(f[i,v]) = 0
);

constraint sum(j in V)(f[t,j]) - sum(i in V)(f[i,t]) = -totalFlow;

% Objective
solve maximize totalFlow;