int: N = 9;
set of int: V = 0..N-1;
int: source = 0;
int: sink = 8;

array[V, V] of int: cap = array2d(V, V, [
  0,  2,  8, 17, 16, 20, 15, 12,  9,
  4,  0, 11,  7,  3, 19, 10, 19,  8,
 14,  7,  0,  7, 13, 19, 18, 20,  5,
 17, 17,  7,  0, 11,  7, 17,  0, 10,
 20, 10,  2, 18,  0, 15,  8,  6, 18,
  4,  9, 12,  1, 17,  0,  0, 13, 18,
 12, 15, 12, 19, 18, 19,  0,  6, 17,
 14,  1, 17, 20, 11, 20,  6,  0,  4,
 19,  3, 19, 12,  8, 18, 17, 13,  0
]);

int: maxCap = max([cap[i,j] | i in V, j in V]);

array[V, V] of var 0..maxCap: f;
var 0..sum(j in V)(cap[source, j]): totalFlow;

constraint forall(i in V, j in V) (f[i,j] <= cap[i,j]);
constraint forall(i in V) (f[i,i] = 0);

constraint forall(k in V where k != source /\ k != sink) (
  sum(j in V)(f[k,j]) = sum(i in V)(f[i,k])
);

constraint totalFlow = sum(j in V)(f[source, j]) - sum(i in V)(f[i, source]);

solve maximize totalFlow;

output [
  "totalFlow=", show(totalFlow), "\n"
];