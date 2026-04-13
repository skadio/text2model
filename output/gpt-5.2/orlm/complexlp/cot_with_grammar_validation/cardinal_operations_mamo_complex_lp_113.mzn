int: N = 6;
set of int: V = 0..N-1;
int: s = 0;
int: t = 5;

array[V, V] of int: cap = array2d(V, V, [
  0, 17, 14, 13, 11,  3,
  1,  0, 18, 14, 12, 16,
  5,  1,  0,  7,  2,  5,
 10, 13, 19,  0,  4, 16,
  3,  0, 13,  0,  0, 14,
 15, 16,  4,  1, 16,  0
]);

int: U = max([cap[i,j] | i in V, j in V]);

array[V, V] of var 0..U: f;
var 0..1000000: maxflow;

constraint forall(i in V, j in V) (f[i,j] <= cap[i,j]);

constraint forall(v in V where v != s /\ v != t) (
  sum(j in V)(f[v,j]) = sum(i in V)(f[i,v])
);

constraint maxflow = sum(j in V)(f[s,j]) - sum(i in V)(f[i,s]);

solve maximize maxflow;

output [
  show(maxflow)
];