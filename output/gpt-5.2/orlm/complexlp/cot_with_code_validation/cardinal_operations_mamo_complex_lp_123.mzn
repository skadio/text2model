% Parameters
int: N = 9;
set of int: V = 0..N-1;
int: s = 0;
int: t = 8;

array[V, V] of int: cap =
array2d(V, V,
[
% from 0
0, 6, 16, 12, 16, 3, 9, 3, 13,
% from 1
2, 0, 0, 20, 13, 7, 20, 11, 13,
% from 2
4, 15, 0, 14, 13, 5, 12, 14, 16,
% from 3
1, 0, 2, 0, 8, 7, 11, 14, 16,
% from 4
4, 19, 7, 14, 0, 1, 20, 14, 16,
% from 5
0, 0, 14, 4, 17, 0, 2, 20, 9,
% from 6
12, 19, 3, 3, 0, 0, 0, 13, 3,
% from 7
8, 19, 16, 4, 6, 13, 9, 0, 15,
% from 8
11, 6, 0, 6, 10, 9, 3, 1, 0
]);

int: U = max([ cap[i,j] | i in V, j in V ]);

% Variables
array[V, V] of var 0..U: f;
var 0..sum(j in V)(cap[s,j]): total_flow;

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
  total_flow = sum(j in V)(f[s,j]) - sum(i in V)(f[i,s]);

constraint
  total_flow = sum(i in V)(f[i,t]) - sum(j in V)(f[t,j]);

% Objective
solve maximize total_flow;