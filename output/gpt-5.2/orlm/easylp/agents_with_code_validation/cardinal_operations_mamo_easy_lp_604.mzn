% Parameters
int: max_x1 = 300;                  % Maximum allocation for department x1
int: max_x2 = 200;                  % Maximum allocation for department x2
int: max_x3 = 500;                  % Maximum allocation for department x3
int: max_x4 = 700;                  % Maximum allocation for department x4

int: sum_x1_x2 = 400;               % Required total allocation for x1 + x2
int: max_sum_x3_x4 = 1000;          % Maximum allowed total allocation for x3 + x4

int: cost_x1 = 20;                  % Cost per unit for x1 (dollars)
int: cost_x2 = 15;                  % Cost per unit for x2 (dollars)
int: cost_x3 = 10;                  % Cost per unit for x3 (dollars)
int: cost_x4 = 5;                   % Cost per unit for x4 (dollars)

% Variables
var 0..max_x1: x1;                  % Allocation to department x1 (integer units)
var 0..max_x2: x2;                  % Allocation to department x2 (integer units)
var 0..max_x3: x3;                  % Allocation to department x3 (integer units)
var 0..max_x4: x4;                  % Allocation to department x4 (integer units)

var 0..(cost_x1*max_x1 + cost_x2*max_x2 + cost_x3*max_x3 + cost_x4*max_x4): total_cost;
                                    % Total cost (dollars), bounded by max possible spend

% Constraints
% Link total cost to allocations and per-unit costs
constraint
  total_cost = cost_x1 * x1 + cost_x2 * x2 + cost_x3 * x3 + cost_x4 * x4;

% Required exact total allocation for departments x1 and x2
constraint
  x1 + x2 = sum_x1_x2;

% Maximum allowed total allocation for departments x3 and x4
constraint
  x3 + x4 <= max_sum_x3_x4;

% Ensure combined allocations for x3 and x4 are at least those of x1 and x2
constraint
  x3 + x4 >= x1 + x2;

% Objective
solve minimize total_cost;

output [
  "x1=", show(x1), " x2=", show(x2), " x3=", show(x3), " x4=", show(x4), "\n",
  "total_cost=", show(total_cost), "\n"
];