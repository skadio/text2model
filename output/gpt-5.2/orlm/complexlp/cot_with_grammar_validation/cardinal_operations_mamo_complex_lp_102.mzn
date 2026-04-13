% Parameters
int: N = 7;
set of int: V = 0..N-1;

int: s = 0;
int: t = 6;

array[V, V] of int: cap =
array2d(V, V,
[
  % from 0
  0, 18,  2, 10, 17,  0, 12,
  % from 1
 14,  0,  3,  1, 19, 18,  2,
  % from 2
 17,  5,  0, 15, 15, 19,  0,
  % from 3
 14, 17,  0,  0, 19,  9, 16,
  % from 4
  2, 13, 15, 12,  0, 20,  5,
  % from 5
  9, 16,  4, 15, 15,  0, 11,
  % from 6
  8, 10, 19, 19, 17, 16,  0
]);

int: U = max([cap[i,j] | i in V, j in V]);

% Variables
array[V, V] of var 0..U: f;
var 0..(sum(j in V)(cap[s,j])): total_flow;

% Constraints
constraint forall(i in V, j in V) (
  f[i,j] <= cap[i,j]
);

constraint forall(i in V, j in V where i == j) (
  f[i,j] = 0
);

constraint forall(v in V where v != s /\ v != t) (
  sum(u in V)(f[u,v]) = sum(w in V)(f[v,w])
);

constraint total_flow = sum(j in V)(f[s,j]) - sum(i in V)(f[i,s]);

constraint total_flow = sum(i in V)(f[i,t]) - sum(j in V)(f[t,j]);

% Objective
solve maximize total_flow;