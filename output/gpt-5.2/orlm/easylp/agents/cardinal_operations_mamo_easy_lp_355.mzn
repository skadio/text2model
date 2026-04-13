% Parameters
% Cost coefficients for each department decision variable
int: c1 = 5;   % cost per unit for electronics (x1)
int: c2 = 3;   % cost per unit for clothing (x2)
int: c3 = 2;   % cost per unit for groceries (x3)
int: c4 = 7;   % cost per unit for home goods (x4)

% Constraint right-hand sides / thresholds
int: rhs_2x1_3x2_max     = 150; % 2*x1 + 3*x2 <= 150
int: rhs_x1_x4_min       = 30;  % x1 + x4 >= 30
int: rhs_x3_x4_diff      = 10;  % x3 - x4 <= 10
int: rhs_4x1_5x2_x3_min  = 80;  % 4*x1 + 5*x2 + x3 >= 80

% Variable bounds (assume non-negative allocations)
int: lb = 0;


% Variables
var int: x1; % allocation for electronics
var int: x2; % allocation for clothing
var int: x3; % allocation for groceries
var int: x4; % allocation for home goods

var int: total_cost; % total cost (objective value)


% Constraints
%--------------------------
% Domain / bounds constraints
%--------------------------
constraint x1 >= lb;
constraint x2 >= lb;
constraint x3 >= lb;
constraint x4 >= lb;

%--------------------------
% Linear budget/space constraints
%--------------------------
% 2*x1 + 3*x2 cannot exceed the maximum capacity
constraint 2*x1 + 3*x2 <= rhs_2x1_3x2_max;

% x1 + x4 must meet the minimum combined allocation
constraint x1 + x4 >= rhs_x1_x4_min;

% x3 - x4 difference upper bound as stated in the problem data
constraint x3 - x4 <= rhs_x3_x4_diff;

% 4*x1 + 5*x2 + x3 must meet the minimum threshold
constraint 4*x1 + 5*x2 + x3 >= rhs_4x1_5x2_x3_min;

%--------------------------
% Total cost definition (objective expression)
%--------------------------
constraint total_cost = c1*x1 + c2*x2 + c3*x3 + c4*x4;


% Objective
solve minimize total_cost;

output [
  "x1=", show(x1), " x2=", show(x2), " x3=", show(x3), " x4=", show(x4), "\n",
  "total_cost=", show(total_cost), "\n"
];