int: N = 9;
set of int: V = 0..N-1;
int: s = 0;
int: t = 8;

array[V, V] of int: cap =
[| 0,  6, 20, 15,  9, 20, 17, 16, 20
 | 6,  0, 17, 10, 18,  9,  3, 11, 18
 | 8, 11,  0,  4, 19,  0,  9,  7, 11
 | 4,  5,  7,  0,  6,  3, 17, 11, 20
 | 7,  3,  8, 11,  0, 19, 12,  6, 11
 | 8, 11,  7, 10, 13,  0,  5, 12, 17
 | 8,  3,  4, 11,  2,  8,  0,  0, 20
 | 9,  9,  1, 20,  7,  1, 15,  0, 11
 | 7, 14,  3, 20,  7,  9,  1,  5,  0 |];

array[V, V] of var 0..20: f;

constraint forall(i,j in V) (
  f[i,j] <= cap[i,j]
);

constraint forall(v in V where v != s /\ v != t) (
  sum(i in V)(f[i,v]) = sum(j in V)(f[v,j])
);

var 0..sum(j in V)(cap[s,j]): maxflow;
constraint maxflow = sum(j in V)(f[s,j]) - sum(i in V)(f[i,s]);

solve maximize maxflow;

output [
  "Maximum flow (Tbps): ", show(maxflow), "\n"
];