% Parameters (with values embedded)
int: c1 = 20;
int: c2 = 30;
int: c3 = 40;
int: c4 = 50;

% To ensure integer feasibility with "half of x4", enforce x4 even.
% Provide practical explicit bounds (nonnegative allocations).
int: UB = 1000;

% Variables
var 0..UB: x1;
var 0..UB: x2;
var 0..UB: x3;
var 0..UB: x4;

% Constraints
constraint x1 + x2 <= 200;
constraint 2*x1 + 3*x3 >= 150;

% (1/2)*x4 - x1 <= 75  ->  x4 - 2*x1 <= 150
constraint x4 - 2*x1 <= 150;

% x3 + (1/2)*x4 - x2 >= 100  ->  2*x3 + x4 - 2*x2 >= 200
constraint 2*x3 + x4 - 2*x2 >= 200;

% enforce x4 even so halves are integral
constraint x4 mod 2 = 0;

% Objective
var int: total_cost = c1*x1 + c2*x2 + c3*x3 + c4*x4;
solve minimize total_cost;

output [
  "x1=", show(x1), " x2=", show(x2), " x3=", show(x3), " x4=", show(x4), "\n",
  "min_total_cost=", show(total_cost), "\n"
];