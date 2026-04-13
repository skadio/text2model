int: n = 4;
set of int: CITIES = 1..n;

array[CITIES, CITIES] of int: cost =
[|  0, 26, 49, 75
 | 26,  0, 19, 52
 | 49, 19,  0, 49
 | 75, 52, 49,  0 |];

array[CITIES] of var CITIES: succ;
array[CITIES] of var CITIES: pred;

constraint forall(i in CITIES)(succ[i] != i);
constraint forall(i in CITIES)(pred[i] != i);

constraint forall(i in CITIES)(
  count(j in CITIES)(succ[j] = i) = 1
);
constraint forall(i in CITIES)(
  count(j in CITIES)(pred[j] = i) = 1
);

constraint forall(i in CITIES)(pred[succ[i]] = i);

constraint circuit(succ);

var int: total_cost = sum(i in CITIES)(cost[i, succ[i]]);

solve minimize total_cost;

output [
  "Minimum total travel cost = ", show(total_cost), "\n",
  "Successor representation (i -> succ[i]):\n",
  concat([ show(i) ++ " -> " ++ show(succ[i]) ++ "\n" | i in CITIES ])
];