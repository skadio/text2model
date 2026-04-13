% Parameters
% Costs per unit for each department
int: c1 = 4;   % cost per unit for department x1
int: c2 = 3;   % cost per unit for department x2
int: c3 = 5;   % cost per unit for department x3
int: c4 = 6;   % cost per unit for department x4

% Integer bounds for each allocation variable
int: x1_lb = 0;  int: x1_ub = 30;
int: x2_lb = 0;  int: x2_ub = 20;
int: x3_lb = 0;  int: x3_ub = 40;
int: x4_lb = 0;  int: x4_ub = 50;

% Variables
% Whole-number allocations to departments
var x1_lb..x1_ub: x1;
var x2_lb..x2_ub: x2;
var x3_lb..x3_ub: x3;
var x4_lb..x4_ub: x4;

% Total cost (decision-dependent)
var int: total_cost = c1*x1 + c2*x2 + c3*x3 + c4*x4;

% Constraints
% Minimum combined allocation for x1 and twice x2
constraint x1 + 2 * x2 >= 10;

% Upper bound on the difference between twice x3 and twice x4
constraint 2 * x3 - 2 * x4 <= 15;

% Exact balance constraint relating x1, x3, and x2
constraint x1 + x3 - 3 * x2 = 8;

% Limit on x1 minus allocations to x2 and x4
constraint x1 - x2 - x4 <= 25;

% Objective
solve minimize total_cost;

output [
  "x1=", show(x1), "\n",
  "x2=", show(x2), "\n",
  "x3=", show(x3), "\n",
  "x4=", show(x4), "\n",
  "total_cost=", show(total_cost), "\n"
];