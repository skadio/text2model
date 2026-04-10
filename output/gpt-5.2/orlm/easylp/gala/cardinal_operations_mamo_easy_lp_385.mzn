% Tour planning / integer linear optimization
% All data embedded as requested.

include "globals.mzn";

% Decision variables: number of tours (whole numbers) to each attraction
var 0..20: x1;   % up to 20
var 0..15: x2;   % up to 15
var 0..25: x3;   % up to 25
var 0..30: x4;   % up to 30

% Constraints
constraint x1 + x2 <= 30;
constraint 2*x3 + x4 <= 40;
constraint x1 + x2 + x3 >= 20;

% "difference between x3 and half of x4 should not exceed 10"
% Use integer form: |x3 - x4/2| <= 10  <=>  |2*x3 - x4| <= 20
constraint abs(2*x3 - x4) <= 20;

% Objective: minimize total cost
var int: total_cost = 100*x1 + 200*x2 + 300*x3 + 400*x4;

solve minimize total_cost;

output [
  "x1 = ", show(x1), "\n",
  "x2 = ", show(x2), "\n",
  "x3 = ", show(x3), "\n",
  "x4 = ", show(x4), "\n",
  "Minimum total cost (units) = ", show(total_cost), "\n"
];