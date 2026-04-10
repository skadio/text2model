include "globals.mzn";

% Data (embedded as requested)
int: c1 = 50;
int: c2 = 100;
int: c3 = 200;
int: c4 = 300;

int: x1_lb = 0;   int: x1_ub = 500;
int: x2_lb = 0;   int: x2_ub = 400;
int: x3_lb = 0;   int: x3_ub = 600;
int: x4_lb = 0;   int: x4_ub = 700;

% Decision variables: number of visitors to each spot (integers)
var x1_lb..x1_ub: x1;
var x2_lb..x2_ub: x2;
var x3_lb..x3_ub: x3;
var x4_lb..x4_ub: x4;

% Constraints
constraint x1 + x2 <= 500;
constraint x2 + x3 >= 300;
constraint abs(x3 - x4) <= 100;
constraint x4 - x1 >= 50;

% Objective: minimize total cost
var int: total_cost = c1*x1 + c2*x2 + c3*x3 + c4*x4;

solve minimize total_cost;

output [
  "x1 = ", show(x1), "\n",
  "x2 = ", show(x2), "\n",
  "x3 = ", show(x3), "\n",
  "x4 = ", show(x4), "\n",
  "Minimum total cost ($) = ", show(total_cost), "\n"
];