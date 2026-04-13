% Tourism promotion allocation (integer linear optimization)
include "globals.mzn";

% Costs
int: c1 = 300;
int: c2 = 200;
int: c3 = 100;
int: c4 = 50;

% Decision variables (whole-number allocations)
% Upper bounds are not explicitly given; set safe bounds implied by constraints.
% From x1 + x2 <= 500 and x4 <= x1 - 150 and 0.5*x4 - x2 <= 400, values won't need to be huge.
var 0..2000: x1;
var 0..2000: x2;
var 0..2000: x3;
var 0..2000: x4;

% Constraints
constraint x1 + x2 <= 500;

% 2*x1 + 3.5*x3 >= 700  -> multiply by 2 to avoid fractions: 4*x1 + 7*x3 >= 1400
constraint 4*x1 + 7*x3 >= 1400;

% x2 - 0.5*x3 - x1 <= 300 -> multiply by 2: 2*x2 - x3 - 2*x1 <= 600
constraint 2*x2 - x3 - 2*x1 <= 600;

% 0.5*x4 - x2 <= 400 -> multiply by 2: x4 - 2*x2 <= 800
constraint x4 - 2*x2 <= 800;

% x4 <= x1 - 150
constraint x4 <= x1 - 150;

% Objective: minimize total promotion cost
var int: total_cost = c1*x1 + c2*x2 + c3*x3 + c4*x4;

solve minimize total_cost;

output [
  "x1 = ", show(x1), "\n",
  "x2 = ", show(x2), "\n",
  "x3 = ", show(x3), "\n",
  "x4 = ", show(x4), "\n",
  "minimum_total_cost = ", show(total_cost), "\n"
];