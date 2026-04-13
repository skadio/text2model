int: N = 8;
set of int: V = 0..N-1;
int: s = 0;
int: t = 7;

array[V, V] of int: cap = [|
  0, 3, 7, 2,18,18,14,10,
  1, 0,10,16,14, 0, 6,10,
  4, 0, 0, 7, 2, 2, 6,10,
  2, 3, 7, 0,20, 8, 6,10,
  1,20, 4, 8, 0,13, 8, 1,
 16, 9,17,17,11, 0, 7, 8,
  3, 7,14, 1,20, 5, 0,13,
  0, 0, 0, 0, 0, 0, 0, 0
|];

int: U = max([cap[i,j] | i in V, j in V]);

array[V, V] of var 0..U: f;
var 0..sum(j in V)(cap[s,j]): flow;

constraint forall(i in V, j in V) (
  f[i,j] <= cap[i,j]
);

constraint forall(i in V where i != s /\ i != t) (
  sum(j in V)(f[i,j]) = sum(j in V)(f[j,i])
);

constraint flow = sum(j in V)(f[s,j]) - sum(j in V)(f[j,s]);

constraint flow = sum(j in V)(f[j,t]) - sum(j in V)(f[t,j]);

solve maximize flow;

output ["max_flow=", show(flow), "\n"];