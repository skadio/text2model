int: n = 5;
set of int: CITIES = 1..n;

array[CITIES, CITIES] of int: cost =
[|  0, 40, 40, 56, 93
 | 40,  0, 52, 71, 90
 | 40, 52,  0, 57, 14
 | 56, 71, 57,  0, 13
 | 93, 90, 14, 13,  0
 |];

array[CITIES] of var CITIES: succ;
array[CITIES] of var CITIES: pred;
array[CITIES] of var 1..n: order;
var int: total_cost;

constraint all_different(succ);
constraint all_different(pred);
constraint forall(i in CITIES)(succ[i] != i /\ pred[i] != i);
constraint forall(i in CITIES)(pred[succ[i]] = i);

constraint order[1] = 1;
constraint forall(i in 2..n)(order[i] >= 2 /\ order[i] <= n);
constraint forall(i in 2..n, j in 2..n where i != j)(
  order[i] - order[j] + n <= n - 1 + n * bool2int(succ[i] != j)
);

constraint total_cost = sum(i in CITIES)(cost[i, succ[i]]);

solve minimize total_cost;