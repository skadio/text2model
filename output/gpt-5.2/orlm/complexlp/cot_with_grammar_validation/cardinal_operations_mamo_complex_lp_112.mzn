int: N = 9;
set of int: V = 0..N-1;
int: s = 0;
int: t = 8;

array[V, V] of int: cap = array2d(V, V,
[
  0,  0, 20, 10,  0,  2, 11,  5, 12,
  7,  0,  5,  9,  9, 16,  1, 17,  7,
  3, 17,  0,  1,  5, 18, 13, 12, 14,
  9, 10,  2,  0, 10, 11, 11,  5, 10,
  7,  5,  1, 19,  0, 19, 12, 14, 15,
 16,  4,  6, 15, 19,  0,  0,  0, 20,
  3,  0, 17, 16, 19,  8,  0,  8,  9,
 14, 11, 13, 17, 10, 13, 20,  0, 16,
 20,  5, 20, 16,  0, 15,  1, 12,  0
]);

int: U = sum(i in V, j in V)(cap[i,j]);

array[V, V] of var 0..U: f;
var 0..U: maxflow;

constraint forall(i in V, j in V) (
  f[i,j] <= cap[i,j]
);

constraint forall(i in V where i != s /\ i != t) (
  sum(j in V)(f[i,j]) = sum(j in V)(f[j,i])
);

constraint maxflow = sum(j in V)(f[s,j]) - sum(j in V)(f[j,s]);

constraint maxflow = sum(j in V)(f[j,t]) - sum(j in V)(f[t,j]);

solve maximize maxflow;

output ["maxflow = \(maxflow)\n"];