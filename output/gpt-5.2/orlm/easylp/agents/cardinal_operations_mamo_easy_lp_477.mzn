% Parameters
int: budget_limit = 200;                 % Maximum total resources available
int: perf_min = 400;                     % Minimum required performance score
int: perf_x_coeff = 3;                   % Performance coefficient for service X
int: perf_y_coeff = 2;                   % Performance coefficient for service Y
int: diff_min = 50;                      % Minimum required difference X - Y
int: cost_x = 500;                       % Cost per unit of X (dollars)
int: cost_y = 300;                       % Cost per unit of Y (dollars)

% Variables
var 0..budget_limit: x;                  % Units allocated to service X (integer, non-negative)
var 0..budget_limit: y;                  % Units allocated to service Y (integer, non-negative)
var 0..(cost_x * budget_limit + cost_y * budget_limit): total_cost; % Total cost (dollars)

% Constraints
% Budget limit: total allocated resources cannot exceed the available budget
constraint
  x + y <= budget_limit;

% Minimum performance requirement: ensure required performance score is met
constraint
  perf_x_coeff * x + perf_y_coeff * y >= perf_min;

% Portfolio balance: enforce minimum difference between service X and Y allocations
constraint
  x - y >= diff_min;

% Total cost definition: compute total_cost from allocations and unit costs
constraint
  total_cost = cost_x * x + cost_y * y;

% Objective
solve minimize total_cost;

output [
  "x = ", show(x), "\n",
  "y = ", show(y), "\n",
  "total_cost = ", show(total_cost), "\n"
];