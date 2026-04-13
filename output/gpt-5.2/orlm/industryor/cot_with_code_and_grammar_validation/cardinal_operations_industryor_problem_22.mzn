% Parameters
int: n = 3;
set of int: P = 1..n;

array[P] of int: labor_per_unit = [3, 2, 6];
array[P] of int: material_per_unit = [4, 3, 6];
array[P] of int: selling_price = [120, 80, 180];
array[P] of int: variable_cost = [60, 40, 80];
array[P] of int: fixed_cost = [2000, 1500, 1000];

int: labor_available = 1500;
int: material_available = 1600;

array[P] of int: unit_profit = [selling_price[i] - variable_cost[i] | i in P];

% Variables
array[P] of var 0..max(labor_available, material_available): x; % production quantities

var int: total_profit;

% Constraints
constraint
  sum(i in P)(labor_per_unit[i] * x[i]) <= labor_available;

constraint
  sum(i in P)(material_per_unit[i] * x[i]) <= material_available;

constraint
  total_profit =
    sum(i in P)(unit_profit[i] * x[i]) - sum(i in P)(fixed_cost[i]);

% Objective
solve maximize total_profit;