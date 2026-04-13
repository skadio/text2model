% Max flow in a directed network (0..8), maximize flow from s=0 to t=8

int: N = 9;
set of int: V = 0..N-1;

int: s = 0;
int: t = 8;

array[V, V] of int: cap = array2d(V, V, [
% from 0
  0, 0,20,10, 0, 2,11, 5,12,
% from 1
  7, 0, 5, 9, 9,16, 1,17, 7,
% from 2
  3,17, 0, 1, 5,18,13,12,14,
% from 3
  9,10, 2, 0,10,11,11, 5,10,
% from 4
  7, 5, 1,19, 0,19,12,14,15,
% from 5
 16, 4, 6,15,19, 0, 0, 0,20,
% from 6
  3, 0,17,16,19, 8, 0, 8, 9,
% from 7
 14,11,13,17,10,13,20, 0,16,
% from 8
 20, 5,20,16, 0,15, 1,12, 0
]);

int: U = sum(i,j in V where cap[i,j] > 0)(cap[i,j]);

array[V, V] of var 0..U: f;
var 0..U: F;

% Capacity constraints (also forces f[i,j]=0 when cap[i,j]=0)
constraint forall(i,j in V)(f[i,j] <= cap[i,j]);

% Flow conservation at intermediate nodes
constraint forall(i in V where i != s /\ i != t)(
  sum(j in V)(f[i,j]) = sum(j in V)(f[j,i])
);

% Define total flow value
constraint F = sum(j in V)(f[s,j]) - sum(j in V)(f[j,s]);
constraint F = sum(j in V)(f[j,t]) - sum(j in V)(f[t,j]);

solve maximize F;

output ["MaxFlow=", show(F), "\n"];