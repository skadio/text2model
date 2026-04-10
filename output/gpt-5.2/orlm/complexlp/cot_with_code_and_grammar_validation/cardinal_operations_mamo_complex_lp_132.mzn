int: N = 8;
set of int: V = 0..N-1;
int: s = 0;
int: t = 7;

array[V, V] of int: cap = [|
  0,  2,  1,  1,  8, 17,  6,  7 |
  4,  0, 14, 14, 13, 19,  4, 19 |
  6, 16,  0,  3, 10,  7, 18, 10 |
 19,  4, 15,  0,  6,  1, 17,  9 |
 12, 15,  3, 14,  0, 18, 20, 14 |
 20,  5, 19,  9, 20,  0, 10,  6 |
  9, 14, 12, 16, 19,  3,  0, 10 |
 20, 16,  6, 16,  8, 16,  4,  0
|];

int: U = max([cap[i,j] | i in V, j in V]);
int: outCapS = sum(j in V)(cap[s,j]);

array[V, V] of var 0..U: f;
var 0..outCapS: F;

constraint forall(i in V, j in V) (
  f[i,j] <= cap[i,j]
);

constraint forall(i in V where i != s /\ i != t) (
  sum(j in V)(f[i,j]) = sum(j in V)(f[j,i])
);

constraint F = sum(j in V)(f[s,j]) - sum(j in V)(f[j,s]);

constraint sum(j in V)(f[j,t]) - sum(j in V)(f[t,j]) = F;

solve maximize F;

output ["MaxFlow = ", show(F), "\n"];