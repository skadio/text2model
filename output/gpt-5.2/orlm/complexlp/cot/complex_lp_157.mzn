% Parameters (with values embedded)
int: num_centers = 6;
int: num_stores = 5;

set of int: Centers = 1..num_centers;
set of int: Stores  = 1..num_stores;

array[Centers] of int: open_cost = [151000, 192000, 114000, 171000, 160000, 120000];

array[Centers, Stores] of int: trans_cost =
[| 2, 3, 3, 3, 5
 | 4, 3, 5, 2, 4
 | 2, 4, 5, 1, 4
 | 2, 5, 4, 1, 1
 | 3, 3, 2, 4, 4
 | 3, 4, 4, 1, 3 |];

array[Stores] of int: demand = [884, 420, 566, 673, 787];
array[Centers] of int: capacity = [1400, 1115, 813, 1041, 1576, 1364];

int: total_demand = sum(s in Stores)(demand[s]);
int: max_cap = max(c in Centers)(capacity[c]);

% Variables
array[Centers] of var bool: open;
array[Centers, Stores] of var 0..max_cap: ship;

var 0..(sum(c in Centers)(open_cost[c]) + total_demand * max(c in Centers, s in Stores)(trans_cost[c,s])): total_cost;

% Constraints
constraint forall(s in Stores)(
  sum(c in Centers)(ship[c,s]) = demand[s]
);

constraint forall(c in Centers)(
  sum(s in Stores)(ship[c,s]) <= capacity[c] * bool2int(open[c])
);

% Objective
constraint total_cost =
  sum(c in Centers)(open_cost[c] * bool2int(open[c])) +
  sum(c in Centers, s in Stores)(trans_cost[c,s] * ship[c,s]);

solve minimize total_cost;

output [
  "Optimal total cost = ", show(total_cost), "\n",
  "Open centers: ", show([bool2int(open[c]) | c in Centers]), "\n",
  "Shipments (center x store):\n",
  concat([ concat([ "  c", show(c), ": ", show([ ship[c,s] | s in Stores ]), "\n" ]) | c in Centers ])
];