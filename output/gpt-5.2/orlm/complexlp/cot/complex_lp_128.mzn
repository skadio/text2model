% Parameters (with values embedded)
int: N = 7;
set of int: V = 0..N-1;
int: source = 0;
int: sink = 6;

array[V, V] of int: cap =
array2d(V, V,
[
 % to:  0  1  2  3  4  5  6
        0,16, 6,16, 2,17,15, % from 0
        7, 0,13, 3, 0, 8,17, % from 1
        3,17, 0,18,11,18,11, % from 2
        9, 0,15, 0, 3, 8,10, % from 3
        3, 6, 1,16, 0,13,10, % from 4
       15,20, 2, 6,18, 0, 9, % from 5
        4, 6, 8,13,16,10, 0  % from 6
]);

% Variables
array[V, V] of var 0..20: f; % flow on each directed arc (bounded by max capacity in data)

var 0..200: maxflow;

% Constraints
constraint forall(i in V, j in V) (
  f[i,j] <= cap[i,j]
);

% flow conservation for all intermediate nodes
constraint forall(v in V where v != source /\ v != sink) (
  sum(j in V)(f[v,j]) = sum(i in V)(f[i,v])
);

% define value of flow (net out of source and net into sink)
constraint maxflow = sum(j in V)(f[source,j]) - sum(i in V)(f[i,source]);
constraint maxflow = sum(i in V)(f[i,sink]) - sum(j in V)(f[sink,j]);

% Objective
solve maximize maxflow;