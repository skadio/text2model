% Parameters
int: N = 8;
set of int: V = 0..N-1;
int: s = 0;
int: t = 7;

array[V, V] of int: cap =
array2d(V, V,
[
  % from 0
  0, 18,  5,  6,  8, 10, 16,  0,
  % from 1
 18,  0,  1, 15, 20, 13,  1,  2,
  % from 2
 18, 16,  0, 19, 15,  4,  9, 10,
  % from 3
 20,  2, 18,  0, 19, 17, 15, 19,
  % from 4
 14, 13, 14,  1,  0,  8, 16, 20,
  % from 5
  0, 17, 18, 10, 17,  0, 16,  6,
  % from 6
  5, 14, 19,  6,  0, 19,  0, 12,
  % from 7
  7, 16, 17, 13,  6,  9,  5,  0
]);

int: U = sum(i in V)(cap[s,i]); % upper bound on max flow (sum of outgoing from source)

% Variables
array[V, V] of var 0..U: f;
var 0..U: maxflow;

% Constraints
constraint
  forall(i in V, j in V)(
    f[i,j] <= cap[i,j]
  );

constraint
  forall(v in V where v != s /\ v != t)(
    sum(i in V)(f[i,v]) = sum(j in V)(f[v,j])
  );

constraint
  maxflow = sum(j in V)(f[s,j]) - sum(i in V)(f[i,s]);

constraint
  maxflow = sum(i in V)(f[i,t]) - sum(j in V)(f[t,j]);

% Objective
solve maximize maxflow;