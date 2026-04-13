% Parameters
int: N = 8;
set of int: V = 0..N-1;
int: s = 0;
int: t = 7;

array[V, V] of int: cap =
array2d(V, V, [
  0,  2,  1,  1,  8, 17,  6,  7,
  4,  0, 14, 14, 13, 19,  4, 19,
  6, 16,  0,  3, 10,  7, 18, 10,
 19,  4, 15,  0,  6,  1, 17,  9,
 12, 15,  3, 14,  0, 18, 20, 14,
 20,  5, 19,  9, 20,  0, 10,  6,
  9, 14, 12, 16, 19,  3,  0, 10,
 20, 16,  6, 16,  8, 16,  4,  0
]);

int: U = max([cap[i,j] | i in V, j in V]);

% Variables
array[V, V] of var 0..U: f;
var 0..sum(j in V)(cap[s,j]): maxflow;

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
  maxflow = sum(j in V)(f[s,j]) - sum(i in V)(f[i,s]);

constraint
  maxflow = sum(i in V)(f[i,t]) - sum(j in V)(f[t,j]);

% Objective
solve maximize maxflow;