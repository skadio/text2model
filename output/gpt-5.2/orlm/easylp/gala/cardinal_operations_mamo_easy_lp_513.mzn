include "globals.mzn";

% Resource allocation (integer units)
var 0..500: x1;
var 0..500: x2;
var 0..500: x3;

% Constraints
constraint x1 + x2 + x3 <= 500;

constraint 5*x1 + 10*x2 >= 1000;

% "Twice and a half of X3" = 2.5*x3; avoid fractions by multiplying by 2:
% |2*(2.5*x3 - x1)| <= 2*300  => |5*x3 - 2*x1| <= 600
constraint abs(5*x3 - 2*x1) <= 600;

% Objective: minimize total cost
var int: total_cost = 50*x1 + 75*x2 + 120*x3;

solve minimize total_cost;

output [
  "x1 = ", show(x1), "\n",
  "x2 = ", show(x2), "\n",
  "x3 = ", show(x3), "\n",
  "minimum_total_cost = $", show(total_cost), "\n"
];