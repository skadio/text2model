include "globals.mzn";

/*
Decision variables: whole-number "investment units"
- Each unit in X1 costs $1000
- Each unit in X2 costs $500
Max allowable investments:
- X1 <= $1500  => X1 units <= 1
- X2 <= $1000  => X2 units <= 2
Other constraints use dollars, so we link units to dollar budgets.
*/

int: total_budget_cap = 2000;

int: cost_per_unit_x1 = 1000;
int: cost_per_unit_x2 = 500;

int: max_dollars_x1 = 1500;
int: max_dollars_x2 = 1000;

int: max_units_x1 = max_dollars_x1 div cost_per_unit_x1; % = 1
int: max_units_x2 = max_dollars_x2 div cost_per_unit_x2; % = 2

var 0..max_units_x1: u1;   % units invested in campaign X1
var 0..max_units_x2: u2;   % units invested in campaign X2

var 0..max_dollars_x1: x1 = cost_per_unit_x1 * u1;  % dollars in X1
var 0..max_dollars_x2: x2 = cost_per_unit_x2 * u2;  % dollars in X2

% Constraints
constraint x1 + x2 <= total_budget_cap;

constraint 3 * x1 - x2 >= 500;

% "difference between the budgets allocated to X1 and twice that of X2 should not exceed 800"
% Interpreted as: x1 - 2*x2 <= 800 (no absolute value mentioned).
constraint x1 - 2 * x2 <= 800;

% Objective: minimize total cost in dollars (same as x1 + x2)
var int: total_cost = x1 + x2;

solve minimize total_cost;

output [
  "Minimum total cost = $", show(total_cost), "\n",
  "u1 (units) = ", show(u1), ", x1 ($) = ", show(x1), "\n",
  "u2 (units) = ", show(u2), ", x2 ($) = ", show(x2), "\n"
];