% Parameters
int: N = 4;
set of int: V = 1..N;
int: source = 1;
int: sink = 4;

array[V, V] of int: cap =
  array2d(V, V,
  [ 0, 5, 7, 0,
    0, 0, 2, 4,
    0, 0, 0, 12,
    0, 0, 0, 0 ]);

int: U = sum(i in V, j in V)(cap[i,j]);

% Variables
array[V, V] of var 0..U: f;
var 0..U: maxflow;

% Constraints
constraint forall(i in V, j in V) (f[i,j] <= cap[i,j]);

constraint forall(i in V)(f[i,i] = 0);

constraint forall(k in V where k != source /\ k != sink)(
  sum(i in V)(f[i,k]) = sum(j in V)(f[k,j])
);

constraint maxflow = sum(j in V)(f[source,j]);
constraint maxflow = sum(i in V)(f[i,sink]);

% Objective
solve maximize maxflow;