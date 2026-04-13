% Parameters
int: max_total_allocation = 200;          % Total allocation limit across X1, X2, X3

float: perf_min = 40.0;                  % Minimum required performance index
float: coef_perf_x1 = 0.5;               % Performance coefficient for X1
float: coef_perf_x2 = -0.3;              % Performance coefficient for X2
float: coef_perf_x3 = 0.4;               % Performance coefficient for X3

int: diff_limit = 70;                    % Limit for 2*X2 - (X1 + X3)

int: cost_x1 = 50;                       % Cost per unit allocated to X1
int: cost_x2 = 30;                       % Cost per unit allocated to X2
int: cost_x3 = 20;                       % Cost per unit allocated to X3


% Variables
var 0..max_total_allocation: x1;         % Allocation to department X1 (integer units)
var 0..max_total_allocation: x2;         % Allocation to department X2 (integer units)
var 0..max_total_allocation: x3;         % Allocation to department X3 (integer units)

var 0..(cost_x1*max_total_allocation + cost_x2*max_total_allocation + cost_x3*max_total_allocation): total_cost;
                                         % Total cost (to be minimized, integer)


% Constraints
% Total allocation budget constraint
constraint
  x1 + x2 + x3 <= max_total_allocation;

% Minimum performance index constraint (ensure correct sign handling for x2 term)
constraint
  coef_perf_x1 * int2float(x1)
+ coef_perf_x2 * int2float(x2)
+ coef_perf_x3 * int2float(x3)
  >= perf_min;

% Department balance / difference constraint: 2*X2 - (X1 + X3) <= 70
constraint
  2 * x2 - (x1 + x3) <= diff_limit;

% Define total cost based on allocations and unit costs
constraint
  total_cost = cost_x1 * x1 + cost_x2 * x2 + cost_x3 * x3;


% Objective
solve minimize total_cost;