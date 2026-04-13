% Hongdou Clothing Factory production planning (embedded data)

set of int: P = 1..3;
array[P] of string: pname = ["Shirt", "Short-sleeve", "Casual Cloth"];

% Per-unit requirements
array[P] of int: labor_per_unit    = [3, 2, 6];
array[P] of int: material_per_unit = [4, 3, 6];

% Economics
array[P] of int: selling_price = [120, 80, 180];
array[P] of int: variable_cost = [60, 40, 80];

% Weekly fixed costs (for using each special equipment)
array[P] of int: fixed_cost = [2000, 1500, 1000];

% Resource availability per week
int: labor_available = 1500;
int: material_available = 1600;

% Decision variables: weekly production quantities and whether the equipment is used
array[P] of var 0..10000: x;     % units produced
array[P] of var bool: use;       % 1 if corresponding equipment is used (and fixed cost incurred)

% Link production to equipment usage (big-M bounds)
array[P] of int: max_x =
  [ min(labor_available div labor_per_unit[p], material_available div material_per_unit[p]) | p in P ];

constraint forall(p in P) (
  x[p] <= max_x[p] * bool2int(use[p])
);

% Resource constraints
constraint sum(p in P)(labor_per_unit[p] * x[p]) <= labor_available;
constraint sum(p in P)(material_per_unit[p] * x[p]) <= material_available;

% Objective: maximize weekly profit
% profit = sum (selling - variable)*x - sum fixed*use
var int: profit =
  sum(p in P)((selling_price[p] - variable_cost[p]) * x[p]) - sum(p in P)(fixed_cost[p] * bool2int(use[p]));

solve maximize profit;

output [
  "Weekly production plan:\n",
  concat([ pname[p] ++ ": " ++ show(x[p]) ++ " units, equipment_used=" ++ show(use[p]) ++ "\n" | p in P ]),
  "Total profit: " ++ show(profit) ++ "\n"
];