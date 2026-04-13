% Parameters
int: total_allocation_cap = 200;                 % Maximum total resources across all departments
float: perf_min = 40.0;                          % Minimum required performance index
int: balance_max = 70;                           % Maximum allowed imbalance in the balancing constraint

float: perf_coef_x1 = 0.5;                       % Performance coefficient for X1
float: perf_coef_x2 = -0.3;                      % Performance coefficient for X2
float: perf_coef_x3 = 0.4;                       % Performance coefficient for X3

int: cost_x1 = 50;                               % Cost per unit allocated to X1
int: cost_x2 = 30;                               % Cost per unit allocated to X2
int: cost_x3 = 20;                               % Cost per unit allocated to X3

int: alloc_ub = total_allocation_cap;            % Simple upper bound for each allocation variable

% Variables
var 0..alloc_ub: x1;                             % Integer units allocated to department X1
var 0..alloc_ub: x2;                             % Integer units allocated to department X2
var 0..alloc_ub: x3;                             % Integer units allocated to department X3

var 0..(cost_x1*alloc_ub + cost_x2*alloc_ub + cost_x3*alloc_ub): total_cost;  % Total cost to minimize

% Constraints

% Total allocation cap across all departments
constraint
  x1 + x2 + x3 <= total_allocation_cap;

% Minimum performance index requirement
constraint
  perf_coef_x1 * int2float(x1)
+ perf_coef_x2 * int2float(x2)
+ perf_coef_x3 * int2float(x3)
  >= perf_min;

% Balancing constraint: 2*X2 minus (X1 + X3) should not exceed balance_max
constraint
  2 * x2 - (x1 + x3) <= balance_max;

% Define total cost from per-department costs
constraint
  total_cost = cost_x1 * x1 + cost_x2 * x2 + cost_x3 * x3;

% Objective
solve minimize total_cost;

% Optional output for inspection
output [
  "x1=", show(x1), " x2=", show(x2), " x3=", show(x3), "\n",
  "total_cost=", show(total_cost), "\n"
];