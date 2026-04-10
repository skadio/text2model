include "globals.mzn";

int: n = 4;
set of int: CITIES = 1..n;

array[CITIES, CITIES] of int: cost =
[|  0, 52, 89, 11
 | 52,  0, 14, 13
 | 89, 14,  0, 87
 | 11, 13, 87,  0
 |];

array[CITIES] of var CITIES: succ;   % successor city in the tour
array[CITIES] of var CITIES: pred;   % predecessor city in the tour

constraint forall(i in CITIES)(succ[i] != i /\ pred[i] != i);
constraint all_different(succ);
constraint all_different(pred);
constraint forall(i in CITIES)(pred[succ[i]] = i);
constraint circuit(succ);

var int: total_cost = sum(i in CITIES)(cost[i, succ[i]]);

solve minimize total_cost;

output [
  "Minimum total travel cost = ", show(total_cost), "\n",
  "Successor mapping (i -> succ[i]): ", show(succ), "\n"
];