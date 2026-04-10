int: N = 7;
set of int: V = 0..N-1;
int: s = 0;
int: t = 6;

array[V, V] of int: cap =
[|  0, 15,  2, 16,  3,  5,  3
 |  7,  0,  0,  0, 19, 15, 16
 | 11, 14,  0, 14,  8, 11,  6
 | 17, 11, 11,  0, 11, 16, 19
 | 10,  4, 17, 20,  0, 12, 17
 |  3,  0,  4,  5, 20,  0,  4
 | 15,  2, 15, 18, 17,  7,  0 |];

array[V, V] of var 0..max(cap): f;

constraint
  forall(i,j in V) (
    f[i,j] <= cap[i,j]
  );

constraint
  forall(v in V where v != s /\ v != t) (
    sum(j in V)(f[v,j]) = sum(i in V)(f[i,v])
  );

var 0..sum(j in V)(cap[s,j]): flow_value;
constraint flow_value = sum(j in V)(f[s,j]) - sum(i in V)(f[i,s]);

solve maximize flow_value;

output [
  "Maximum flow from hub ", show(s), " to hub ", show(t), ": ", show(flow_value), "\n",
  "Flow matrix (rows=from, cols=to):\n"
] ++
[
  concat([ if j==0 then "" else " " endif ++ show(f[i,j]) | j in V ]) ++ "\n"
  | i in V
];