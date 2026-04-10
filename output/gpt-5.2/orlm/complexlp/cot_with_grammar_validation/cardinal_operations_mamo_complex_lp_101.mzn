int: N = 6;
set of int: V = 0..N-1;
int: s = 0;
int: t = 5;

array[V, V] of int: cap = [|
  0,  7,  8,  1,  2,  4 |
 15,  0, 16,  0,  9, 13 |
  9,  1,  0,  9, 13, 13 |
 10, 11, 19,  0,  1, 12 |
 15, 16,  7, 11,  0, 19 |
 10, 12, 12, 12, 20,  0
|];

int: U = max([cap[i,j] | i in V, j in V]);

array[V, V] of var 0..U: f;

var 0..sum(j in V)(cap[s,j]): F;

constraint forall(i in V, j in V) (
  f[i,j] <= cap[i,j]
);

constraint forall(i in V where i != s /\ i != t) (
  sum(j in V)(f[j,i]) = sum(j in V)(f[i,j])
);

constraint F = sum(j in V)(f[s,j]) - sum(j in V)(f[j,s]);

constraint F = sum(j in V)(f[j,t]) - sum(j in V)(f[t,j]);

solve maximize F;

output [show(F)];