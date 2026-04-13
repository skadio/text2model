include "globals.mzn";

% Decision variables: whole-number investments
var 0..1000: x1;
var 0..1000: x2;
var 0..1000: x3;

% Budget constraint
constraint x1 + x2 + x3 <= 1000;

% 1) 2*x1 - 3*x2 >= 200
constraint 2*x1 - 3*x2 >= 200;

% 2) x1 cannot exceed (1/2)*x3 by more than 300:
%    x1 - (1/2)x3 <= 300  <=>  2*x1 - x3 <= 600
constraint 2*x1 - x3 <= 600;

% 3) 2.5*x2 - x1 - x3 >= -500:
%    (5/2)x2 - x1 - x3 >= -500  <=>  5*x2 - 2*x1 - 2*x3 >= -1000
constraint 5*x2 - 2*x1 - 2*x3 >= -1000;

% Objective: minimize total cost/return units
var 0..70000: total_cost = 50*x1 + 60*x2 + 70*x3;

solve minimize total_cost;

output [
  "x1 = ", show(x1), "\n",
  "x2 = ", show(x2), "\n",
  "x3 = ", show(x3), "\n",
  "total_cost = ", show(total_cost), "\n"
];