include "globals.mzn";

int: N = 3;
int: M = 3;
set of int: P = 1..N;
set of int: K = 1..M;

array[P, K] of int: t = array2d(P, K, [
  2, 3, 1,
  4, 2, 3,
  3, 5, 2
]);

int: sumT = sum(p in P, k in K)(t[p,k]);

array[P] of var P: seq;
array[P, K] of var 0..sumT: start;
array[P, K] of var 0..sumT: finish;
var 0..sumT: makespan;

constraint all_different(seq);

constraint forall(pos in P, k in K) (
  finish[pos,k] = start[pos,k] + t[seq[pos],k]
);

constraint forall(pos in P, k in 1..M-1) (
  start[pos,k+1] >= finish[pos,k]
);

constraint forall(pos in 1..N-1, k in K) (
  start[pos+1,k] >= finish[pos,k]
);

constraint makespan = finish[N, M];

solve minimize makespan;

output [
  "seq = ", show(seq), "\n",
  "makespan = ", show(makespan), "\n",
  "start = ", show(start), "\n",
  "finish = ", show(finish), "\n"
];