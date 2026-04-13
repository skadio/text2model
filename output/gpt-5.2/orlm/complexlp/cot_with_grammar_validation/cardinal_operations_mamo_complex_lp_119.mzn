% Parameters
int: N = 6;
set of int: V = 0..N-1;
int: s = 0;
int: t = 5;

array[V, V] of int: cap =
  array2d(V, V,
  [
    % from 0
    0, 4, 12, 19, 13, 11,
    % from 1
    20, 0, 13, 9, 10, 0,
    % from 2
    14, 8, 0, 5, 13, 11,
    % from 3
    5, 15, 18, 0, 6, 7,
    % from 4
    8, 17, 20, 14, 0, 9,
    % from 5
    9, 19, 19, 11, 4, 0
  ]);

% Variables
array[V, V] of var 0..20: f;
var 0..sum(i in V)(cap[s,i]): maxflow;

% Constraints
constraint forall(i in V, j in V) (
  f[i,j] <= cap[i,j]
);

constraint forall(i in V where i != s /\ i != t) (
  sum(j in V)(f[j,i]) = sum(j in V)(f[i,j])
);

constraint maxflow = sum(j in V)(f[s,j]) - sum(j in V)(f[j,s]);
constraint maxflow = sum(j in V)(f[j,t]) - sum(j in V)(f[t,j]);

% Objective
solve maximize maxflow;