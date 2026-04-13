include "globals.mzn";

int: nProducts = 3;
int: nMachines = 3;

set of int: P = 1..nProducts;
set of int: M = 1..nMachines;

array[P, M] of int: t = array2d(P, M, [
  2, 3, 1,
  4, 2, 3,
  3, 5, 2
]);

int: BIGM = sum(p in P, m in M)(t[p,m]);

array[P, M] of var 0..BIGM: start;
array[P, M] of var 0..BIGM: finish;

array[P] of var P: seq;
array[P] of var 1..nProducts: pos;

var 0..BIGM: makespan;

constraint all_different(seq);
constraint inverse(seq, pos);

constraint forall(p in P, m in M) (
  finish[p,m] = start[p,m] + t[p,m]
);

constraint forall(p in P, m in 2..nMachines) (
  start[p,m] >= finish[p,m-1]
);

constraint forall(a in P, b in P where a != b) (
  (pos[a] < pos[b]) ->
    forall(m in M) (
      start[b,m] >= finish[a,m]
    )
);

constraint forall(p in P) (
  makespan >= finish[p,nMachines]
);

solve minimize makespan;

output [
  "makespan=", show(makespan), "\n",
  "seq=", show(seq), "\n",
  "start=\n",
  concat([ concat([ "(" ++ show(p) ++ "," ++ show(m) ++ ")=" ++ show(start[p,m]) ++ "  " | m in M ]) ++ "\n"
         | p in P ])
];