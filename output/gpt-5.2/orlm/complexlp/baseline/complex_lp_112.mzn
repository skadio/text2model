int: N = 9;
set of int: V = 0..N-1;

int: source = 0;
int: sink = 8;

array[V, V] of int: cap = array2d(V, V, [
  % from 0
  0, 0, 20, 10, 0, 2, 11, 5, 12,
  % from 1
  7, 0, 5, 9, 9, 16, 1, 17, 7,
  % from 2
  3, 17, 0, 1, 5, 18, 13, 12, 14,
  % from 3
  9, 10, 2, 0, 10, 11, 11, 5, 10,
  % from 4
  7, 5, 1, 19, 0, 19, 12, 14, 15,
  % from 5
  16, 4, 6, 15, 19, 0, 0, 0, 20,
  % from 6
  3, 0, 17, 16, 19, 8, 0, 8, 9,
  % from 7
  14, 11, 13, 17, 10, 13, 20, 0, 16,
  % from 8
  20, 5, 20, 16, 0, 15, 1, 12, 0
]);

int: totalCapOutSource = sum(j in V) (cap[source,j]);
array[V, V] of var 0..totalCapOutSource: f;

constraint
  forall(i in V, j in V) (
    f[i,j] <= cap[i,j]
  );

constraint
  forall(v in V where v != source /\ v != sink) (
    sum(i in V) f[i,v] = sum(j in V) f[v,j]
  );

var 0..totalCapOutSource: maxflow = sum(j in V) f[source,j];

solve maximize maxflow;

output [
  "Max flow = ", show(maxflow), "\n"
];