include "globals.mzn";

% Data (from problem statement)
int: c1 = 2;
int: c2 = 3;
int: c3 = 4;
int: c4 = 5;

% Decision variables: whole-number allocations
% Upper bounds chosen to be safely large given constraints/objective
var 0..1000: x1;
var 0..1000: x2;
var 0..1000: x3;
var 0..1000: x4;

% Constraints
constraint x1 + x2 <= 100;
constraint 2 * x1 + x3 >= 50;
constraint x2 - 3 * x4 <= 20;

% x4 - half of x1 >= 10  <=>  2*x4 - x1 >= 20 (avoid fractions)
constraint 2 * x4 - x1 >= 20;

% Objective: minimize total cost
var int: total_cost = c1*x1 + c2*x2 + c3*x3 + c4*x4;

solve minimize total_cost;

output [
  "x1 = ", show(x1), "\n",
  "x2 = ", show(x2), "\n",
  "x3 = ", show(x3), "\n",
  "x4 = ", show(x4), "\n",
  "minimum total cost = ", show(total_cost), "\n"
];