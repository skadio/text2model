% Parameters
int: N = 9;
int: S = 0;
int: T = 8;
set of int: V = 0..N-1;

array[V, V] of int: cap =
array2d(V, V, [
  % from 0
  0, 4, 7, 15, 4, 7, 2, 10, 12,
  % from 1
  0, 0, 17, 2, 5, 1, 10, 14, 5,
  % from 2
  0, 7, 0, 17, 9, 13, 10, 7, 5,
  % from 3
  0, 16, 4, 0, 11, 9, 12, 18, 12,
  % from 4
  0, 3, 0, 18, 0, 5, 2, 0, 19,
  % from 5
  0, 15, 7, 20, 20, 0, 20, 12, 9,
  % from 6
  0, 8, 14, 13, 1, 17, 0, 10, 19,
  % from 7
  0, 5, 5, 16, 5, 7, 3, 0, 19,
  % from 8
  0, 19, 18, 0, 4, 7, 1, 20, 0
]);

int: U = sum(i in V, j in V)(cap[i,j]);

% Variables
array[V, V] of var 0..U: f;
var 0..U: maxflow;

% Constraints
constraint
  forall(i in V, j in V) (
    f[i,j] <= cap[i,j]
  );

constraint
  forall(v in V where v != S /\ v != T) (
    sum(i in V)(f[i,v]) = sum(j in V)(f[v,j])
  );

constraint
  maxflow = sum(j in V)(f[S,j]) - sum(i in V)(f[i,S]);

constraint
  maxflow = sum(i in V)(f[i,T]) - sum(j in V)(f[T,j]);

% Objective
solve maximize maxflow;