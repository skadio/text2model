int: N = 8;
set of int: V = 0..N-1;

int: s = 0;
int: t = 7;

array[V, V] of int: cap =
[| 0,  9,  6,  1,  8, 14,  1, 17
 | 1,  0,  6, 14, 16,  8, 19, 15
 | 4,  7,  0,  9,  1,  2,  9,  4
 |11,  5, 14,  0, 17,  6, 20, 13
 | 8,  5, 20,  0,  0, 16,  5,  5
 |15, 18,  9,  1, 19,  0, 16,  0
 |20, 15,  1,  0, 11,  6,  0, 19
 | 4, 18, 10,  2,  1, 20, 14,  0 |];

array[V, V] of var 0..20: f;

constraint
  forall(i in V, j in V) (
    f[i,j] <= cap[i,j]
  );

constraint
  forall(v in V where v != s /\ v != t) (
    sum(j in V)(f[v,j]) = sum(i in V)(f[i,v])
  );

var int: maxflow = sum(j in V)(f[s,j]) - sum(i in V)(f[i,s]);

solve maximize maxflow;

output [
  "Maximum flow (MW) from station ", show(s), " to station ", show(t), ": ",
  show(maxflow), "\n"
];