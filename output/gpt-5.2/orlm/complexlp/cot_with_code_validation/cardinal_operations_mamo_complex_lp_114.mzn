% Parameters
int: N = 6;
set of int: V = 0..N-1;

int: source = 0;
int: sink = 5;

array[V, V] of int: cap =
array2d(V, V, [
  0,  9, 13,  0, 20, 16,
  6,  0, 19, 11, 14, 15,
 11,  6,  0,  8,  3, 10,
 16,  2, 17,  0,  1, 17,
  4, 12,  5, 16,  0, 15,
  7, 19, 18,  6,  8,  0
]);

int: total_cap_out_source = sum(j in V)(cap[source, j]);

% Variables
array[V, V] of var 0..total_cap_out_source: f;
var 0..total_cap_out_source: maxflow;

% Constraints
constraint forall(i in V, j in V) (
  f[i,j] <= cap[i,j]
);

constraint forall(v in V where v != source /\ v != sink) (
  sum(i in V)(f[i,v]) = sum(j in V)(f[v,j])
);

constraint maxflow = sum(j in V)(f[source, j]) - sum(i in V)(f[i, source]);

constraint maxflow = sum(i in V)(f[i, sink]) - sum(j in V)(f[sink, j]);

% Objective
solve maximize maxflow;