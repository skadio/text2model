% Parameters
int: N = 9;
set of int: V = 0..N-1;
int: s = 0;
int: t = 8;

array[V, V] of int: cap =
array2d(V, V, [
  % from 0
  0, 15, 12,  9,  7, 12,  5, 20, 10,
  % from 1
  6,  0,  8,  0, 19, 14, 17,  9, 16,
  % from 2
 19, 11,  0,  0, 13, 14, 17, 10, 13,
  % from 3
 15,  4,  5,  0,  2, 18,  6, 17, 19,
  % from 4
  2,  8,  2,  4,  0,  6, 14, 20, 18,
  % from 5
 14,  9, 18,  7,  4,  0, 11, 11, 13,
  % from 6
 12, 14, 12,  4, 18,  6,  0,  5,  4,
  % from 7
 20,  1,  6, 17,  4,  2, 11,  0,  9,
  % from 8
 16,  6, 14,  0, 17, 17,  6,  9,  0
]);

int: U = sum(i in V)(cap[s,i]); % valid upper bound on max flow

% Variables
array[V, V] of var 0..U: f;
var 0..U: maxflow;

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
    sum(i in V)(f[i,v]) = sum(j in V)(f[v,j])
  );

constraint
  maxflow = sum(j in V)(f[s,j]) - sum(i in V)(f[i,s]);

constraint
  maxflow = sum(i in V)(f[i,t]) - sum(j in V)(f[t,j]);

% Objective
solve maximize maxflow;