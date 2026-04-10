include "globals.mzn";

% Decision variables: integer allocations for each unit type
var 0..150: x1;
var 0..100: x2;
var 0..80:  x3;
var 0..20:  x4;

% Logistics constraint
constraint x1 + x2 <= 200;

% Strategic objective constraint:
% 2*x1 + 3.5*x3 >= 400  <=> 4*x1 + 7*x3 >= 800 (multiply by 2)
constraint 4*x1 + 7*x3 >= 800;

% Difference constraint:
% |x2 - 0.5*x4| <= 50  <=>  |2*x2 - x4| <= 100 (multiply by 2)
constraint abs(2*x2 - x4) <= 100;

% "After subtracting x1 and x3 from x2, it should not exceed 70"
constraint x2 - x1 - x3 <= 70;

% Support points (cost) per unit
int: c1 = 10000;
int: c2 = 5000;
int: c3 = 8000;
int: c4 = 6000;

% Objective: minimize total support points (already integral)
var int: total_cost = c1*x1 + c2*x2 + c3*x3 + c4*x4;

solve minimize total_cost;

output [
  "x1 = ", show(x1), "\n",
  "x2 = ", show(x2), "\n",
  "x3 = ", show(x3), "\n",
  "x4 = ", show(x4), "\n",
  "Minimum total support points (rounded) = ", show(total_cost), "\n"
];