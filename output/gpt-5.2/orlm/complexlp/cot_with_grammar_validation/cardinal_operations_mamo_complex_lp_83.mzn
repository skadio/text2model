include "globals.mzn";

int: N = 5;
set of int: SHOPS = 1..N;

array[SHOPS, SHOPS] of int: cost =
  [|  0, 13, 87, 76, 50
   | 13,  0, 15, 65, 85
   | 87, 15,  0, 45, 81
   | 76, 65, 45,  0, 80
   | 50, 85, 81, 80,  0 |];

array[SHOPS] of var SHOPS: succ;
array[SHOPS] of var 1..N: order;
var 0..1000000: total_cost;

constraint circuit(succ);

constraint order[1] = 1;
constraint forall(i in 2..N)(order[i] >= 2 /\ order[i] <= N);
constraint forall(i in 2..N, j in 2..N where i != j)(
  order[i] - order[j] + (N - 1) * bool2int(succ[i] = j) <= N - 2
);

constraint total_cost = sum(i in SHOPS)(cost[i, succ[i]]);

solve minimize total_cost;

output ["total_cost = \(total_cost)\n"];