int: N = 9;
set of int: V = 0..N-1;
int: s = 0;
int: t = 8;

array[V, V] of int: cap = array2d(V, V, [
  0, 11, 11, 14,  6, 11,  4, 15,  9,
  0,  0,  5,  8,  7, 10,  3,  2,  1,
  0, 18,  0,  6,  4, 18,  7,  5,  2,
  0,  9,  3,  0, 20,  6,  2,  4,  7,
  0,  4,  8,  5,  0,  9,  1,  6, 10,
  0,  7, 12,  4,  3,  0, 14,  2, 11,
  0,  2,  6,  9,  7,  5,  0, 20,  4,
  0, 10,  2,  6,  8,  3, 11,  0, 13,
  0,  1,  4,  7,  2,  6,  5,  9,  0
]);

int: UB = sum(j in V)(cap[s,j]);

array[V, V] of var 0..UB: f;
var 0..UB: maxflow;

constraint forall(i in V, j in V) (f[i,j] <= cap[i,j]);

constraint forall(i in V, j in V where cap[i,j] = 0) (f[i,j] = 0);

constraint forall(v in V where v != s /\ v != t) (
  sum(u in V)(f[u,v]) = sum(w in V)(f[v,w])
);

constraint maxflow = sum(j in V)(f[s,j]) - sum(i in V)(f[i,s]);

solve :: int_search([f[i,j] | i in V, j in V], first_fail, indomain_max, complete)
maximize maxflow;

output ["maxflow = ", show(maxflow), "\n"];