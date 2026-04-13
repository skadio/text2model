int: N = 8;
set of int: V = 0..N-1;
int: s = 0;
int: t = 7;

array[V, V] of int: cap = array2d(V, V, [
  0,  3,  3,  5, 13,  7, 14, 17,
  5,  0,  0,  2, 18, 20,  1, 17,
  2, 18,  0, 10, 14, 15,  8, 18,
 20,  7, 11,  0, 13,  2,  8, 12,
 20, 20, 12,  7,  0, 11,  2, 14,
  5, 16, 15, 19, 11,  0,  1,  8,
 10,  3, 14, 18, 13,  6,  0,  7,
  9,  3, 14, 13,  6,  5,  9,  0
]);

int: U = sum(i in V, j in V)(cap[i,j]);

array[V, V] of var 0..U: f;
var 0..U: maxflow;

constraint forall(i in V, j in V) (
  f[i,j] <= cap[i,j]
);

constraint forall(v in V where v != s /\ v != t) (
  sum(i in V)(f[i,v]) = sum(j in V)(f[v,j])
);

constraint maxflow = sum(j in V)(f[s,j]) - sum(i in V)(f[i,s]);

solve maximize maxflow;

output ["maxflow = ", show(maxflow), "\n"];