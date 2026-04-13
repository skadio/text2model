include "globals.mzn";

int: n = 6;
set of int: CITIES = 1..n;

array[CITIES, CITIES] of int: cost =
[|
  0, 23, 50, 92, 56, 91 |
  23, 0, 38, 25, 25, 69 |
  50, 38, 0, 66, 51, 76 |
  92, 25, 66, 0, 97, 37 |
  56, 25, 51, 97, 0, 30 |
  91, 69, 76, 37, 30, 0
|];

int: start = 1;

array[CITIES] of var CITIES: succ;
array[CITIES] of var 1..n: pos;
var int: total_cost;

constraint forall(i in CITIES)(succ[i] != i);
constraint circuit(succ);

constraint pos[start] = 1;

constraint forall(i in CITIES, j in CITIES where i != j)(
  (pos[j] = (pos[i] mod n) + 1) <-> (succ[i] = j)
);

constraint total_cost = sum(i in CITIES)(cost[i, succ[i]]);

solve minimize total_cost;

output [
  "total_cost = ", show(total_cost), "\n",
  "succ = ", show(succ), "\n",
  "pos = ", show(pos), "\n"
];