include "globals.mzn";

int: N = 7;
set of int: LOC = 1..N;

array[LOC, LOC] of int: dist =
[| 0, 86, 49, 57, 31, 69, 50
 | 86, 0, 68, 79, 93, 24, 5
 | 49, 68, 0, 16, 7, 72, 67
 | 57, 79, 16, 0, 90, 69, 1
 | 31, 93, 7, 90, 0, 86, 59
 | 69, 24, 72, 69, 86, 0, 81
 | 50, 5, 67, 1, 59, 81, 0
|];

int: start = 1;
set of int: CUST = 2..N;

int: UB = sum(i in LOC, j in LOC where i != j)(dist[i, j]);

array[LOC] of var LOC: succ;
array[LOC] of var 1..N: ord;
var 0..UB: total_dist;

constraint circuit(succ);

constraint succ[start] != start;
constraint forall(i in CUST)(succ[i] != i);

constraint ord[start] = 1;
constraint forall(i in CUST)(ord[i] >= 2 /\ ord[i] <= N);
constraint forall(i in CUST, j in CUST where i != j)(
  ord[i] - ord[j] + N * (if succ[i] == j then 1 else 0 endif) <= N - 1
);

constraint total_dist = sum(i in LOC)(dist[i, succ[i]]);

solve minimize total_dist;

output [
  "total_dist = ", show(total_dist), "\n",
  "succ = ", show(succ), "\n",
  "ord = ", show(ord), "\n"
];