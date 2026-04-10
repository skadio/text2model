include "globals.mzn";

int: N = 4;
set of int: CITIES = 1..N;

array[CITIES, CITIES] of int: cost =
  [| 0, 41, 55, 22
   | 41, 0, 47, 47
   | 55, 47, 0, 35
   | 22, 47, 35, 0 |];

array[CITIES] of var CITIES: succ;
array[CITIES] of var 1..N: pos;
var int: total_cost;

constraint circuit(succ);

constraint alldifferent(pos);

constraint forall(i in CITIES)(pos[i] >= 1 /\ pos[i] <= N);
constraint forall(i in CITIES, j in CITIES where i != j)(
  pos[i] - pos[j] + N * bool2int(succ[i] = j) <= N - 1
);

constraint total_cost = sum(i in CITIES)(cost[i, succ[i]]);

solve minimize total_cost;

output [
  "total_cost = ", show(total_cost), "\n",
  "succ = ", show(succ), "\n"
];