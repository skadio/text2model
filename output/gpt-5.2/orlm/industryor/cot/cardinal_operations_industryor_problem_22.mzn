% Parameters (with values embedded)
int: n = 3;
set of int: P = 1..n;

% Product indices: 1=Shirt, 2=Short-sleeve, 3=Casual Cloth
array[P] of int: labor_per_unit    = [3, 2, 6];
array[P] of int: material_per_unit = [4, 3, 6];
array[P] of int: selling_price     = [120, 80, 180];
array[P] of int: variable_cost     = [60, 40, 80];
array[P] of int: fixed_cost        = [2000, 1500, 1000];

int: labor_available    = 1500;
int: material_available = 1600;

% Variables
array[P] of var 0..100000: x;     % units produced
array[P] of var 0..1: y;          % 1 if equipment is used (produce > 0), else 0

% Constraints
constraint forall(i in P) (x[i] >= 0);

constraint sum(i in P)(labor_per_unit[i] * x[i]) <= labor_available;
constraint sum(i in P)(material_per_unit[i] * x[i]) <= material_available;

% Link production to equipment usage (if x[i] > 0 then y[i] = 1)
% Safe big-M bounds derived from resource limits:
array[P] of int: M = [
  min(labor_available div labor_per_unit[1], material_available div material_per_unit[1]),
  min(labor_available div labor_per_unit[2], material_available div material_per_unit[2]),
  min(labor_available div labor_per_unit[3], material_available div material_per_unit[3])
];
constraint forall(i in P) (x[i] <= M[i] * y[i]);

% Objective
var int: profit =
  sum(i in P)((selling_price[i] - variable_cost[i]) * x[i]) - sum(i in P)(fixed_cost[i] * y[i]);

solve maximize profit;