% Parameters
int: N = 9;
set of int: V = 0..N-1;
int: s = 0;
int: t = 8;

array[V, V] of int: cap =
array2d(V, V,
[
  0, 13, 19, 17,  7,  7, 11,  7,  7,
  9,  0, 19, 20, 10, 19, 20, 19,  3,
  0, 16,  0,  0, 10,  2, 14,  9,  9,
  6,  0,  5,  0,  7, 18, 15, 20,  7,
 18, 19, 12,  0,  0, 16, 20, 10,  4,
  3,  4,  8,  9, 20,  0,  7,  8,  1,
  3, 14, 14, 16,  1, 12,  0, 10, 10,
  9, 20, 19,  4,  9, 16,  1,  0,  6,
  7, 15, 14, 18, 18, 11, 18,  0,  0
]);

int: U = max([cap[i,j] | i in V, j in V]); % upper bound on any arc flow

% Variables
array[V, V] of var 0..U: f;
var 0..sum(j in V)(cap[s,j]): total_flow;

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
  total_flow = sum(j in V)(f[s,j]) - sum(i in V)(f[i,s]);

constraint
  total_flow = sum(i in V)(f[i,t]) - sum(j in V)(f[t,j]);

% Objective
solve maximize total_flow;