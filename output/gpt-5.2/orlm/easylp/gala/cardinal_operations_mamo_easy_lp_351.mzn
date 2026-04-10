% Healthcare resource allocation - linear integer optimization
include "globals.mzn";

% Costs (units per allocation)
int: c1 = 100;
int: c2 = 50;
int: c3 = 30;
int: c4 = 200;

% Bounds (not specified numerically in the prompt).
% Use nonnegative allocations; choose safe, finite upper bounds so the model is runnable.
% These can be adjusted if true bounds are known.
int: U = 1000;

var 0..U: x1; % general medicine
var 0..U: x2; % surgery
var 0..U: x3; % diagnostics
var 0..U: x4; % research

% Constraints
constraint x1 + x2 >= 10;
constraint x3 + x4 >= 20;
constraint 5*x1 - 2*x2 <= 0;
constraint 3*x3 - x4 >= 0;

% Objective: minimize total cost
var int: total_cost = c1*x1 + c2*x2 + c3*x3 + c4*x4;

solve minimize total_cost;

output [
  "x1=", show(x1), " x2=", show(x2), " x3=", show(x3), " x4=", show(x4), "\n",
  "Minimum total cost = ", show(total_cost), "\n"
];