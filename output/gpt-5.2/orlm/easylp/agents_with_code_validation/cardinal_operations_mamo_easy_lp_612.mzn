% Parameters
% All data embedded as per instructions (no .dzn expected)

int: land_limit = 1000;              % Maximum combined allocation for x1 + x2
int: diversity_min = 500;            % Minimum required for 2*x3 + 3*x4
int: balance_diff_max = 200;         % Maximum allowed difference between x1 and x4

int: cost1 = 50;                     % Cost per unit for crop x1
int: cost2 = 30;                     % Cost per unit for crop x2
int: cost3 = 20;                     % Cost per unit for crop x3
int: cost4 = 10;                     % Cost per unit for crop x4

% Safe explicit variable bounds (non-negative allocations, integers)
int: x1_ub = 1000;                   % From x1 + x2 <= 1000
int: x2_ub = 1000;                   % From x1 + x2 <= 1000
int: x3_ub = 2000;                   % From x3 >= 2*x2 and x2 <= 1000
int: x4_ub = 5000;                   % Safe loose bound

% Variables
var 0..x1_ub: x1;                    % Allocation for crop x1 (integer units)
var 0..x2_ub: x2;                    % Allocation for crop x2 (integer units)
var 0..x3_ub: x3;                    % Allocation for crop x3 (integer units)
var 0..x4_ub: x4;                    % Allocation for crop x4 (integer units)

var int: total_cost;                 % Total cost to minimize

% Constraints
% Land availability: total allocation for crops x1 and x2 cannot exceed the land limit
constraint x1 + x2 <= land_limit;

% Crop diversity / soil health: 2*x3 + 3*x4 must meet or exceed the minimum requirement
constraint 2 * x3 + 3 * x4 >= diversity_min;

% Balance between cash and food crops: difference between x1 and x4 bounded
constraint abs(x1 - x4) <= balance_diff_max;

% Climate/soil condition: (1/2)*x3 >= x2  ==>  x3 >= 2*x2 (integer-safe form)
constraint x3 >= 2 * x2;

% Total cost definition
constraint total_cost = cost1 * x1 + cost2 * x2 + cost3 * x3 + cost4 * x4;

% Objective
solve minimize total_cost;

output [
  "x1=", show(x1), " x2=", show(x2), " x3=", show(x3), " x4=", show(x4), "\n",
  "total_cost=", show(total_cost), "\n"
];