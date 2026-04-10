% Project task scheduling / linear integer optimization
% All data embedded as requested.

include "globals.mzn";

% Decision variables: whole hours
var 0..30: x1;
var 0..20: x2;
var 0..15: x3;

% Objective: minimize total productivity score
var int: total_productivity = 8*x1 + 5*x2 + 6*x3;

% Constraints
constraint 2*x1 + 4*x2 + 3*x3 <= 40;

% x1 + (1/2)x2 - (1/4)x3 >= 10  -> multiply by 4
constraint 4*x1 + 2*x2 - x3 >= 40;

% (5/2)x2 - (x1 + (3/4)x3) <= -20  -> multiply by 4
constraint 10*x2 - 4*x1 - 3*x3 <= -80;

solve minimize total_productivity;

output [
  "x1 = ", show(x1), "\n",
  "x2 = ", show(x2), "\n",
  "x3 = ", show(x3), "\n",
  "Minimum total productivity score (rounded) = ", show(total_productivity), "\n"
];