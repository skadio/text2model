int: N = 8;
set of int: V = 0..N-1;
int: s = 0;
int: t = 7;

array[V, V] of int: cap =
array2d(V, V, [
  0, 18,  5,  6,  8, 10, 16,  0,
 18,  0,  1, 15, 20, 13,  1,  2,
 18, 16,  0, 19, 15,  4,  9, 10,
 20,  2, 18,  0, 19, 17, 15, 19,
 14, 13, 14,  1,  0,  8, 16, 20,
  0, 17, 18, 10, 17,  0, 16,  6,
  5, 14, 19,  6,  0, 19,  0, 12,
  7, 16, 17, 13,  6,  9,  5,  0
]);

int: U = max([cap[i,j] | i in V, j in V]);

array[V, V] of var 0..U: f;
var 0..U*N: maxflow;

constraint forall(i in V, j in V where cap[i,j] = 0) ( f[i,j] = 0 );
constraint forall(i in V, j in V where cap[i,j] > 0) ( f[i,j] <= cap[i,j] );

constraint forall(v in V where v != s /\ v != t) (
  sum(j in V)(f[v,j]) = sum(i in V)(f[i,v])
);

constraint maxflow = sum(j in V)(f[s,j]) - sum(i in V)(f[i,s]);

solve maximize maxflow;

output ["maxflow = ", show(maxflow), "\n"];