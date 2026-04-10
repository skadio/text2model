% Parameters
% Capacity / constraint limits
int: max_total_production = 1000;      % Total units capacity
int: min_performance_metric = 500;     % Minimum required performance metric
int: max_balance_metric = 400;         % Maximum allowed balance metric

% Performance coefficients: 5*X + 3*Y - 1*Z
int: perf_coef_x = 5;
int: perf_coef_y = 3;
int: perf_coef_z = -1;

% Balance coefficients: 1*X - 1*Y + 1*Z
int: bal_coef_x = 1;
int: bal_coef_y = -1;
int: bal_coef_z = 1;

% Unit costs
int: cost_x = 10;
int: cost_y = 15;
int: cost_z = 20;

% Variables
var 0..max_total_production: units_x;  % Units produced of product X (integer, non-negative)
var 0..max_total_production: units_y;  % Units produced of product Y (integer, non-negative)
var 0..max_total_production: units_z;  % Units produced of product Z (integer, non-negative)

% Derived variables for clarity (bounded to safe ranges)
var 0..((cost_x + cost_y + cost_z) * max_total_production): total_cost;
var -max_total_production..(perf_coef_x*max_total_production + perf_coef_y*max_total_production): performance_metric;
var -max_total_production..(bal_coef_x*max_total_production + bal_coef_z*max_total_production): balance_metric;

% Constraints
% --- Total production capacity constraint ---
constraint
  units_x + units_y + units_z <= max_total_production;

% --- Define performance metric and enforce minimum requirement ---
constraint
  performance_metric =
    perf_coef_x * units_x +
    perf_coef_y * units_y +
    perf_coef_z * units_z;

constraint
  performance_metric >= min_performance_metric;

% --- Define balance metric and enforce maximum allowance ---
constraint
  balance_metric =
    bal_coef_x * units_x +
    bal_coef_y * units_y +
    bal_coef_z * units_z;

constraint
  balance_metric <= max_balance_metric;

% --- Define total cost from unit costs and production quantities ---
constraint
  total_cost =
    cost_x * units_x +
    cost_y * units_y +
    cost_z * units_z;

% Objective
solve minimize total_cost;

% Optional output (useful for checking the optimum)
output [
  "units_x=", show(units_x), "\n",
  "units_y=", show(units_y), "\n",
  "units_z=", show(units_z), "\n",
  "performance_metric=", show(performance_metric), "\n",
  "balance_metric=", show(balance_metric), "\n",
  "total_cost=", show(total_cost), "\n"
];