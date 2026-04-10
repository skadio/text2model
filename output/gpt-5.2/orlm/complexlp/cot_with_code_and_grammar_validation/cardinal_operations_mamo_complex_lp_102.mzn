% Parameters
int: N = 7;
set of int: V = 0..N-1;

int: s = 0;
int: t = 6;

array[V, V] of int: cap =
array2d(V, V,
[
  % to:    0,  1,  2,  3,  4,  5,  6
          0, 18,  2, 10, 17,  0, 12,  % from 0
         14,  0,  3,  1, 19, 18,  2,  % from 1
         17,  5,  0, 15, 15, 19,  0,  % from 2
         14, 17,  0,  0, 19,  9, 16,  % from 3
          2, 13, 15, 12,  0, 20,  5,  % from 4
          9, 16,  4, 15, 15,  0, 11,  % from 5
          8, 10, 19, 19, 17, 16,  0   % from 6
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
  forall(v in V where v != s /\ v != t) (
    sum(i in V)(f[i,v]) = sum(j in V)(f[v,j])
  );

constraint
  maxflow = sum(j in V)(f[s,j]) - sum(i in V)(f[i,s]);

constraint
  maxflow = sum(i in V)(f[i,t]) - sum(j in V)(f[t,j]);

% Objective
solve maximize maxflow;