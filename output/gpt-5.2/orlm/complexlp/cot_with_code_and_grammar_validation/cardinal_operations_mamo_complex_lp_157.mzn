int: M = 6;
int: N = 5;

set of int: DC = 1..M;
set of int: ST = 1..N;

array[DC] of int: open_cost = [151000, 192000, 114000, 171000, 160000, 120000];
array[DC] of int: capacity  = [1400, 1115, 813, 1041, 1576, 1364];

array[ST] of int: demand = [884, 420, 566, 673, 787];

array[DC, ST] of int: ship_cost =
  [| 2, 3, 3, 3, 5
   | 4, 3, 5, 2, 4
   | 2, 4, 5, 1, 4
   | 2, 5, 4, 1, 1
   | 3, 3, 2, 4, 4
   | 3, 4, 4, 1, 3 |];

int: total_demand = sum(s in ST)(demand[s]);

array[DC] of var bool: open;
array[DC, ST] of var 0..total_demand: x;

int: max_ship_cost = 5;
int: max_total_cost = sum(d in DC)(open_cost[d]) + total_demand * max_ship_cost;

var 0..max_total_cost: total_cost;

constraint forall(s in ST) (
  sum(d in DC)(x[d, s]) = demand[s]
);

constraint forall(d in DC) (
  sum(s in ST)(x[d, s]) <= capacity[d] * bool2int(open[d])
);

constraint total_cost =
  sum(d in DC)(open_cost[d] * bool2int(open[d])) +
  sum(d in DC, s in ST)(ship_cost[d, s] * x[d, s]);

solve minimize total_cost;

output [
  "total_cost=", show(total_cost), "\n",
  "open=", show(open), "\n",
  "shipments=\n",
  concat([ concat([ if s = 1 then "" else " " endif ++ show(x[d,s]) | s in ST ]) ++ "\n" | d in DC ])
];