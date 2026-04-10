% Parameters
int: N = 4;
set of int: V = 1..N;

int: source = 1;
int: sink = 4;

array[V, V] of int: cap = array2d(V, V,
[
  0, 8, 7, 0,
  0, 0, 2, 4,
  0, 0, 0, 7,
  0, 0, 0, 0
]);

int: U = sum(i,j in V)(cap[i,j]); % safe upper bound on total flow value

% Variables
array[V, V] of var 0..U: f;
var 0..U: maxflow;

% Constraints
constraint forall(i,j in V)(
  f[i,j] <= cap[i,j]
);

constraint maxflow = sum(j in V)(f[source,j]) - sum(i in V)(f[i,source]);

constraint forall(v in V where v != source /\ v != sink)(
  sum(i in V)(f[i,v]) = sum(j in V)(f[v,j])
);

constraint sum(i in V)(f[i,sink]) - sum(j in V)(f[sink,j]) = maxflow;

% Objective
solve maximize maxflow;