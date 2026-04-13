% Parameters (with values embedded)
int: N = 7;
set of int: V = 0..N-1;
int: source = 0;
int: sink = 6;

array[V, V] of int: cap =
  array2d(V, V,
  [ 0,20,19,18, 0,11, 2,
   18, 0,15,10, 0, 9, 0,
   18, 4, 0,11,15, 0,13,
   17, 3,15, 0, 2, 4, 4,
    2,11,17,17, 0, 2,17,
   12, 4,16,13, 5, 0, 3,
    7, 9,17,18,16, 8, 0]);

% Variables
array[V, V] of var 0..20: f; % upper bound 20 is max capacity in cap matrix
var 0..200: maxflow;         % safe upper bound

% Constraints
constraint forall(i in V, j in V) (
  f[i,j] <= cap[i,j]
);

% Flow conservation for intermediate nodes
constraint forall(k in V where k != source /\ k != sink) (
  sum(j in V)(f[k,j]) = sum(i in V)(f[i,k])
);

% Define objective flow value: net out of source (equivalently net into sink)
constraint maxflow = sum(j in V)(f[source,j]) - sum(i in V)(f[i,source]);

% Objective
solve maximize maxflow;