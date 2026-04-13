% Parameters
int: c1 = 20;          % Cost per unit for department x1
int: c2 = 30;          % Cost per unit for department x2
int: c3 = 10;          % Cost per unit for department x3
int: c4 = 15;          % Cost per unit for department x4

int: ub_x1x2 = 1000;      % Upper bound for x1 + x2
int: ub_2x3x4 = 800;      % Upper bound for 2*x3 + x4
int: lb_3x1_4x2_x3 = 500; % Lower bound for 3*x1 + 4*x2 - x3

% Variables
var 0..1000: x1;  % Allocation to department x1
var 0..1000: x2;  % Allocation to department x2
var 0..800:  x3;  % Allocation to department x3
var 0..800:  x4;  % Allocation to department x4

% Upper bound computed from variable bounds (safe bound for search)
var 0..(c1*1000 + c2*1000 + c3*800 + c4*800): total_cost;

% Constraints
% Total cost definition
constraint total_cost = c1 * x1 + c2 * x2 + c3 * x3 + c4 * x4;

% Resource/budget constraints
constraint x1 + x2 <= ub_x1x2;
constraint 2 * x3 + x4 <= ub_2x3x4;

% Minimum requirement constraint
constraint 3 * x1 + 4 * x2 - x3 >= lb_3x1_4x2_x3;

% Relationship constraint
constraint x2 >= 2 * x4;

% Objective
solve minimize total_cost;

% (Optional) output for inspection
output [
  "x1=", show(x1), " x2=", show(x2), " x3=", show(x3), " x4=", show(x4), "\n",
  "total_cost=", show(total_cost), "\n"
];