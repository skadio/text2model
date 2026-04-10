int: N = 9;
set of int: V = 0..N-1;

int: source = 0;
int: sink = 8;

array[V, V] of int: cap = array2d(V, V, [
  % from 0
  0, 4, 7, 15, 4, 7, 2, 10, 12,
  % from 1
  0, 0, 17, 2, 5, 1, 10, 14, 5,
  % from 2
  0, 7, 0, 17, 9, 13, 10, 7, 5,
  % from 3
  0, 16, 4, 0, 11, 9, 12, 18, 12,
  % from 4
  0, 3, 0, 18, 0, 5, 2, 0, 19,
  % from 5
  0, 15, 7, 20, 20, 0, 20, 12, 9,
  % from 6
  0, 8, 14, 13, 1, 17, 0, 10, 19,
  % from 7
  0, 5, 5, 16, 5, 7, 3, 0, 19,
  % from 8
  0, 19, 18, 0, 4, 7, 1, 20, 0
]);

array[V, V] of var 0..20: f;

constraint
  forall(i, j in V) (
    f[i,j] <= cap[i,j]
  );

constraint
  forall(k in V where k != source /\ k != sink) (
    sum(i in V)(f[i,k]) = sum(j in V)(f[k,j])
  );

var int: maxflow = sum(j in V)(f[source,j]) - sum(i in V)(f[i,source]);

solve maximize maxflow;

output [
  "Maximum flow (thousands of units per hour) = ", show(maxflow), "\n"
];