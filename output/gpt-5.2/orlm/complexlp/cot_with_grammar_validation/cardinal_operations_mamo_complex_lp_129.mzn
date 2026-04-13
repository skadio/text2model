% Parameters
int: N = 6;
set of int: V = 0..N-1;
int: s = 0;
int: t = 5;

array[V, V] of int: cap =
  array2d(V, V,
  [  0, 11,  8, 11, 20, 16,
    15,  0, 11, 16,  0, 20,
     7,  4,  0,  4, 11,  0,
     4,  8, 14,  0, 19,  0,
    10,  0,  6, 19,  0, 13,
    10, 15, 20, 19, 10,  0 ]);

int: maxCap = max([cap[i,j] | i in V, j in V]);

% Variables
array[V, V] of var 0..maxCap: f;
var 0..(sum(j in V)(cap[s,j])): max_flow;

% Constraints
constraint forall(i in V, j in V) (f[i,j] <= cap[i,j]);

constraint forall(k in V where k != s /\ k != t) (
  sum(i in V)(f[i,k]) = sum(j in V)(f[k,j])
);

constraint max_flow = sum(j in V)(f[s,j]) - sum(i in V)(f[i,s]);
constraint max_flow = sum(i in V)(f[i,t]) - sum(j in V)(f[t,j]);

% Objective
solve maximize max_flow;