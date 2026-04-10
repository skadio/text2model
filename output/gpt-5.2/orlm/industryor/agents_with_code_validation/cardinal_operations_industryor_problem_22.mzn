% Parameters
% Products (fixed set embedded from the problem description)
set of int: P = 1..3;
int: SHIRT = 1;
int: SHORT_SLEEVE = 2;
int: CASUAL = 3;

% Resource availability (per week)
int: labor_available = 1500;
int: material_available = 1600;

% Per-unit requirements and economics (by product)
array[P] of int: labor_per_unit    = [3, 2, 6];
array[P] of int: material_per_unit = [4, 3, 6];
array[P] of int: selling_price     = [120, 80, 180];
array[P] of int: variable_cost     = [60, 40, 80];

% Weekly fixed costs for equipment used by each product
array[P] of int: fixed_cost = [2000, 1500, 1000];

% Derived parameter: unit contribution margin (selling - variable)
array[P] of int: unit_margin = [selling_price[i] - variable_cost[i] | i in P];

% Variables
% Units produced per week for each product (nonnegative integers)
array[P] of var 0..max(labor_available, material_available): x;

% Total profit (can be negative if fixed costs exceed margins)
var int: profit;

% Constraints
% Resource capacity constraints (weekly labor and material limits)
constraint
  sum(p in P)(labor_per_unit[p] * x[p]) <= labor_available;

constraint
  sum(p in P)(material_per_unit[p] * x[p]) <= material_available;

% Profit definition (total contribution margin minus fixed equipment costs)
% Note: fixed costs are incurred weekly for the three special equipment.
constraint
  profit =
    sum(p in P)(unit_margin[p] * x[p]) - sum(p in P)(fixed_cost[p]);

% Objective
solve maximize profit;