int: N = 4;
set of int: V = 1..N;

int: s = 1;
int: t = 4;

array[V, V] of int: cap =
[| 0, 5, 7, 0
 | 0, 0, 2, 4
 | 0, 0, 0, 12
 | 0, 0, 0, 0
 |];

array[V, V] of var 0..12: f;

constraint
  forall(i, j in V) (
    f[i,j] <= cap[i,j]
  );

constraint
  forall(i, j in V) (
    cap[i,j] = 0 -> f[i,j] = 0
  );

constraint
  forall(v in V where v != s /\ v != t) (
    sum(i in V)(f[i,v]) = sum(j in V)(f[v,j])
  );

var int: maxflow = sum(j in V)(f[s,j]) - sum(i in V)(f[i,s]);

solve maximize maxflow;

output [
  "Maximum flow (integer): ", show(maxflow), "\n",
  "Flow matrix f[i,j]:\n"
] ++
[
  if j = 1 then "" else "" endif ++
  show(f[i,j]) ++ if j = N then "\n" else " " endif
  | i in V, j in V
];