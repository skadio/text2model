include "globals.mzn";

% Data (embedded as required)
int: c1 = 1000;
int: c2 = 2000;
int: c3 = 3000;
int: c4 = 4000;

int: x1_max = 500;
int: x2_max = 400;
int: x3_max = 600;
int: x4_max = 700;

% Decision variables: integer resource allocations
var 0..x1_max: x1;
var 0..x2_max: x2;
var 0..x3_max: x3;
var 0..x4_max: x4;

% Constraints
constraint x1 + x2 <= 500;
constraint x3 + x4 <= 800;

% "half of X1 must be at least one-fourth more than X3 by no less than 50 units"
% Interpreted as: (1/2)X1 >= (5/4)X3 + 50
% Multiply by 4 to keep integers: 2*X1 >= 5*X3 + 200
constraint 2*x1 >= 5*x3 + 200;

% "difference between three-quarters of X4 and X2 must be at least 100"
% Interpreted as: (3/4)X4 - X2 >= 100
% Multiply by 4: 3*X4 - 4*X2 >= 400
constraint 3*x4 - 4*x2 >= 400;

% Objective: minimize total cost
var int: total_cost = c1*x1 + c2*x2 + c3*x3 + c4*x4;

solve minimize total_cost;

output [
  "x1 = ", show(x1), "\n",
  "x2 = ", show(x2), "\n",
  "x3 = ", show(x3), "\n",
  "x4 = ", show(x4), "\n",
  "total_cost = ", show(total_cost), "\n"
];