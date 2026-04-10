% Parameters
int: N = 8;
set of int: V = 0..N-1;

int: s = 0;
int: t = 7;

array[V, V] of int: cap =
  array2d(V, V,
  [
    % from 0
    0, 9, 6, 1, 8, 14, 1, 17,
    % from 1
    1, 0, 6, 14, 16, 8, 19, 15,
    % from 2
    4, 7, 0, 9, 1, 2, 9, 4,
    % from 3
    11, 5, 14, 0, 17, 6, 20, 13,
    % from 4
    8, 5, 20, 0, 0, 16, 5, 5,
    % from 5
    15, 18, 9, 1, 19, 0, 16, 0,
    % from 6
    20, 15, 1, 0, 11, 6, 0, 19,
    % from 7
    4, 18, 10, 2, 1, 20, 14, 0
  ]);

int: U = sum(i in V, j in V)(cap[i,j]);

% Variables
array[V, V] of var 0..U: f;
var 0..U: maxflow;

% Constraints
constraint forall(i in V, j in V) (
  f[i,j] <= cap[i,j]
);

constraint forall(v in V where v != s /\ v != t) (
  sum(i in V)(f[i,v]) = sum(j in V)(f[v,j])
);

constraint maxflow = sum(j in V)(f[s,j]) - sum(i in V)(f[i,s]);

constraint maxflow = sum(i in V)(f[i,t]) - sum(j in V)(f[t,j]);

% Objective
solve maximize maxflow;