% Annual training budget allocation across three departments (X, Y, Z)
% Budgets must be multiples of $1,000 and meet minimums, with total <= $100,000.
% Objective: minimize total cost, where cost is computed from per-employee training costs.

include "globals.mzn";

% --- Embedded data (all in dollars) ---
int: total_budget_cap = 100000;

int: minX = 30000;
int: minY = 20000;
int: minZ = 10000;

int: cost_per_employee_X = 5000;
int: cost_per_employee_Y = 3000;
int: cost_per_employee_Z = 2000;

int: budget_unit = 1000; % budgets must be multiples of $1,000

% --- Decision variables: budgets in dollars ---
var 0..total_budget_cap: bx;
var 0..total_budget_cap: by;
var 0..total_budget_cap: bz;

% --- Constraints ---
constraint bx + by + bz <= total_budget_cap;

constraint bx >= minX;
constraint by >= minY;
constraint bz >= minZ;

% Budgets must be multiples of $1,000
constraint bx mod budget_unit = 0;
constraint by mod budget_unit = 0;
constraint bz mod budget_unit = 0;

% If we interpret "total cost" as (cost per employee) * (number of employees trained),
% and "budget" is exactly what's spent, then:
% bx = cost_per_employee_X * ex, etc.
% This enforces spending to correspond to an integer number of employees trained.
var 0..total_budget_cap div cost_per_employee_X: ex;
var 0..total_budget_cap div cost_per_employee_Y: ey;
var 0..total_budget_cap div cost_per_employee_Z: ez;

constraint bx = cost_per_employee_X * ex;
constraint by = cost_per_employee_Y * ey;
constraint bz = cost_per_employee_Z * ez;

% Objective: minimize total cost spent
var 0..total_budget_cap: total_cost = bx + by + bz;

solve minimize total_cost;

output [
  "Minimum total cost = $", show(total_cost), "\n",
  "Budgets: X=$", show(bx), " (employees ", show(ex), ")\n",
  "         Y=$", show(by), " (employees ", show(ey), ")\n",
  "         Z=$", show(bz), " (employees ", show(ez), ")\n"
];