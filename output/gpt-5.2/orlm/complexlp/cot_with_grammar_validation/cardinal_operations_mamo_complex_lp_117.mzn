int: N = 9;
set of int: V = 0..N-1;
int: s = 0;
int: t = 8;

array[V, V] of int: cap = array2d(V, V, [
  0, 7, 4, 17, 4, 18, 17, 5, 14,
  2, 0, 11, 10, 1, 19, 6, 16, 13,
  8, 15, 0, 5, 1, 5, 11, 17, 18,
  2, 5, 0, 0, 6, 17, 1, 16, 14,
  15, 6, 20, 15, 0, 7, 13, 6, 19,
  15, 2, 8, 2, 3, 0, 2, 9, 2,
  10, 12, 11, 10, 19, 9, 0, 17, 1,
  0, 20, 15, 19, 20, 18, 14, 0, 8,
  16, 13, 3, 3, 20, 19, 2, 7, 0
]);

int: maxCap = max([cap[i,j] | i in V, j in V]);

array[V, V] of var 0..maxCap: f;
var 0..sum([cap[s,j] | j in V]): total_flow;

constraint forall(i in V, j in V) (
  f[i,j] <= cap[i,j]
);

constraint forall(i in V where i != s /\ i != t) (
  sum(j in V)(f[j,i]) = sum(j in V)(f[i,j])
);

constraint total_flow = sum(j in V)(f[s,j]) - sum(j in V)(f[j,s]);

solve maximize total_flow;

output ["max_flow = ", show(total_flow), "\n"];