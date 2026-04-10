% Parameters
int: N = 9;
set of int: V = 0..N-1;
int: s = 0;
int: t = 8;

array[V, V] of int: cap =
array2d(V, V, [
  % from 0 to 0..8
  0, 9, 7, 18, 0, 0, 7, 0, 2,
  % from 1 to 0..8
  15, 0, 11, 5, 20, 15, 18, 9, 15,
  % from 2 to 0..8
  3, 8, 0, 10, 16, 18, 8, 0, 20,
  % from 3 to 0..8
  13, 3, 7, 0, 20, 13, 16, 6, 20,
  % from 4 to 0..8
  7, 20, 2, 4, 0, 9, 3, 14, 2,
  % from 5 to 0..8
  17, 10, 5, 1, 4, 0, 4, 3, 20,
  % from 6 to 0..8
  0, 20, 10, 10, 15, 5, 0, 1, 10,
  % from 7 to 0..8
  10, 3, 9, 4, 3, 13, 18, 0, 20,
  % from 8 to 0..8
  2, 12, 10, 5, 15, 14, 0, 10, 0
]);

int: UB = sum(i in V)(cap[s,i]);

% Variables
array[V, V] of var 0..UB: f;
var 0..UB: maxflow;

% Constraints
constraint
  forall(i in V, j in V) (
    f[i,j] <= cap[i,j]
  );

constraint
  forall(i in V) (
    f[i,i] = 0
  );

constraint
  forall(v in V where v != s /\ v != t) (
    sum(u in V)(f[u,v]) = sum(w in V)(f[v,w])
  );

constraint
  maxflow = sum(j in V)(f[s,j]) - sum(i in V)(f[i,s]);

constraint
  maxflow = sum(i in V)(f[i,t]) - sum(j in V)(f[t,j]);

% Objective
solve maximize maxflow;