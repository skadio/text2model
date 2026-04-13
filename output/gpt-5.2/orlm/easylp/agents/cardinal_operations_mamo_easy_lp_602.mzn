% Parameters
% Cost coefficients for each department allocation x1..x4
int: c1 = 2;
int: c2 = 3;
int: c3 = 4;
int: c4 = 5;

% Constraint right-hand sides / limits
int: max_x1_x2 = 1000;          % x1 + x2 <= 1000
int: min_service = 500;         % 2*x1 + 3*x2 >= 500
int: max_diff_x3_x1 = 200;      % x3 - x1 <= 200
int: min_x4_over_x2 = 150;      % x4 - x2 >= 150

% Variable bounds (explicitly set to keep variables bounded)
int: lb = 0;
int: ub = 10000;

% Variables
var lb..ub: x1;  % allocation for department 1 (integer units)
var lb..ub: x2;  % allocation for department 2 (integer units)
var lb..ub: x3;  % allocation for department 3 (integer units)
var lb..ub: x4;  % allocation for department 4 (integer units)

var int: total_cost; % total operating cost (objective)

% Constraints
% Budget limit on combined allocations for departments 1 and 2
constraint x1 + x2 <= max_x1_x2;

% Minimum service level requirement from departments 1 and 2
constraint 2 * x1 + 3 * x2 >= min_service;

% Balance constraint: department 3 should not exceed department 1 by more than the allowed difference
constraint x3 - x1 <= max_diff_x3_x1;

% Strategic requirement: department 4 must be at least a fixed amount above department 2
constraint x4 - x2 >= min_x4_over_x2;

% Define total operating cost from per-department cost coefficients
constraint total_cost = c1 * x1 + c2 * x2 + c3 * x3 + c4 * x4;

% Objective
solve minimize total_cost;

output [
  "x1=", show(x1), "\n",
  "x2=", show(x2), "\n",
  "x3=", show(x3), "\n",
  "x4=", show(x4), "\n",
  "total_cost=", show(total_cost), "\n"
];