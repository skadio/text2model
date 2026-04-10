% Max flow in a directed network (source s to sink t)

int: N = 9;
set of int: V = 0..N-1;

int: s = 0;
int: t = 8;

array[V, V] of int: cap =
array2d(V, V,
[
  0,  5,  2,  7, 17,  4,  1,  2, 13,
 12,  0, 15, 18,  8,  9,  8,  1, 15,
 17, 16,  0, 20, 17, 13,  2, 19,  6,
  5,  9, 14,  0, 10, 18, 20,  9, 18,
 12, 14,  7,  6,  0,  6, 17,  4,  9,
 12, 11, 10,  1, 13,  0, 14, 12, 14,
 13,  7,  3,  9,  1, 14,  0,  7, 16,
 18, 15,  8,  0, 12, 13,  5,  0, 17,
  3, 11, 15, 14,  0,  4, 18, 16,  0
]);

int: U = sum(i in V)(cap[s,i]); % simple upper bound on max flow

array[V, V] of var 0..U: f;
var 0..U: F;

% Capacity constraints
constraint forall(i in V, j in V) (
  f[i,j] <= cap[i,j]
);

% Flow conservation (excluding source and sink)
constraint forall(v in V where v != s /\ v != t) (
  sum(i in V)(f[i,v]) = sum(j in V)(f[v,j])
);

% Define objective flow value (net out of source == net into sink)
constraint F = sum(j in V)(f[s,j]) - sum(i in V)(f[i,s]);
constraint F = sum(i in V)(f[i,t]) - sum(j in V)(f[t,j]);

solve maximize F;

output ["MaxFlow = \(F)\n"];