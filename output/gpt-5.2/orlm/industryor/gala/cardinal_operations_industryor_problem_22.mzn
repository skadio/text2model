% Hongdou Clothing Factory weekly production planning (maximize profit)
% Data embedded as requested.

int: n = 3;
set of int: P = 1..n;

% Products: 1=Shirt, 2=Short-sleeve, 3=Casual cloth
array[P] of string: name = ["Shirt","Short-sleeve","Casual cloth"];

array[P] of int: labor_per_unit    = [3, 2, 6];
array[P] of int: material_per_unit = [4, 3, 6];
array[P] of int: selling_price     = [120, 80, 180];
array[P] of int: variable_cost     = [60, 40, 80];
array[P] of int: fixed_cost        = [2000, 1500, 1000];

int: labor_available = 1500;
int: material_available = 1600;

array[P] of int: unit_profit = [selling_price[p] - variable_cost[p] | p in P];

% Decision variables: weekly production quantities (integer units)
array[P] of var 0..10000: x;

% Resource constraints
constraint sum(p in P)(labor_per_unit[p] * x[p]) <= labor_available;
constraint sum(p in P)(material_per_unit[p] * x[p]) <= material_available;

% Objective: maximize total profit = contribution margin - fixed costs
var int: total_profit =
  sum(p in P)(unit_profit[p] * x[p]) - sum(p in P)(fixed_cost[p]);

solve maximize total_profit;

output [
  "Total profit = ", show(total_profit), "\n",
  "Production plan (units/week):\n",
  concat([ name[p] ++ ": " ++ show(x[p]) ++ "\n" | p in P ]),
  "Labor used = ", show(sum(p in P)(labor_per_unit[p] * x[p])), " / ", show(labor_available), "\n",
  "Material used = ", show(sum(p in P)(material_per_unit[p] * x[p])), " / ", show(material_available), "\n"
];