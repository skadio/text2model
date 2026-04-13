% Parameters
int: N = 4;
set of int: V = 1..N;
int: source = 1;
int: sink = 4;

array[V, V] of int: cap =
  array2d(V, V,
    [
      0, 8, 7, 0,
      0, 0, 2, 4,
      0, 0, 0, 7,
      0, 0, 0, 0
    ]);

% Variables
array[V, V] of var 0..8: f; % upper bound tightened below with capacity constraints

var 0..20: maxflow;

% Constraints
constraint forall(i in V, j in V) (
  f[i,j] >= 0
);

constraint forall(i in V, j in V) (
  f[i,j] <= cap[i,j]
);

constraint forall(i in V where i != source /\ i != sink) (
  sum(j in V)(f[i,j]) = sum(j in V)(f[j,i])
);

constraint maxflow = sum(j in V)(f[source,j]) - sum(j in V)(f[j,source]);

constraint maxflow = sum(j in V)(f[j,sink]) - sum(j in V)(f[sink,j]);

% Objective
solve maximize maxflow;