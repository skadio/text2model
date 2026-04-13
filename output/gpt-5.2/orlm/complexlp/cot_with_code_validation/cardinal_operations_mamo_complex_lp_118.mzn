% Maximum flow from source s to sink t in a directed capacitated network

% Parameters
int: N = 8;
set of int: V = 0..N-1;

int: s = 0;
int: t = 7;

% Use array2d to coerce the literal (which is 1..N x 1..N) into indices 0..N-1
array[V, V] of int: cap = array2d(V, V,
[
  0,  5, 16, 11,  2, 10, 17,  2,
  8,  0, 14, 14,  2,  7, 11,  1,
 17, 20,  0, 16, 13,  0,  6,  1,
  3, 16, 10,  0, 19, 12,  3, 15,
 15, 12, 19, 18,  0, 14, 12, 15,
  2, 20, 20, 17,  4,  0, 10, 17,
 15, 13, 13,  5, 10, 15,  0, 19,
 10,  3, 14, 11,  5, 20,  4,  0
]);

int: U = max([cap[i,j] | i in V, j in V]);

% Variables
array[V, V] of var 0..U: f;
var 0..(N * U): total_flow;

% Capacity constraints (also forces f[i,i]=0 since cap[i,i]=0)
constraint forall(i in V, j in V) (
  f[i,j] <= cap[i,j]
);

% Flow conservation (excluding source and sink)
constraint forall(v in V where v != s /\ v != t) (
  sum(i in V)(f[i,v]) = sum(j in V)(f[v,j])
);

% Total flow definition: net outflow from source
constraint total_flow = sum(j in V)(f[s,j]) - sum(i in V)(f[i,s]);

% Optional consistency for sink (implied by conservation, but harmless)
constraint total_flow = sum(i in V)(f[i,t]) - sum(j in V)(f[t,j]);

solve maximize total_flow;