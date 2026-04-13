int: N = 5;
int: M = 3;
set of int: JOBS = 1..N;
set of int: MACHS = 1..M;

array[JOBS, MACHS] of float: p =
  array2d(JOBS, MACHS, [
    3.0, 1.0, 1.0,
    2.0, 1.5, 1.0,
    3.0, 1.2, 1.3,
    2.0, 2.0, 2.0,
    2.1, 2.0, 3.0
  ]);

int: UB = ceil(sum(i in JOBS, j in MACHS)(p[i,j]));

array[JOBS, MACHS] of var 0..UB: s;
array[JOBS, MACHS] of var 0..UB: e;
var 0..UB: makespan;

constraint
  forall(i in JOBS, j in MACHS) (
    e[i,j] = s[i,j] + ceil(p[i,j])
  );

constraint
  forall(i in JOBS, j in 1..M-1) (
    s[i,j+1] >= e[i,j]
  );

constraint
  forall(j in MACHS, i1 in JOBS, i2 in JOBS where i1 < i2) (
    e[i1,j] <= s[i2,j] \/ e[i2,j] <= s[i1,j]
  );

constraint
  makespan = max([ e[i,M] | i in JOBS ]);

solve minimize makespan;

output [
  "makespan=", show(makespan), "\n",
  "s=\n", show(s), "\n",
  "e=\n", show(e), "\n"
];