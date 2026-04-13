% Shipping cargo allocation (integer loads), minimize total cost
% Data is embedded as requested.

include "globals.mzn";

% Decision variables: whole-number loads on each ship
var 0..1000: x1;
var 0..1000: x2;
var 0..800:  x3;
var 0..800:  x4;

% Capacity constraints
constraint x1 + x2 <= 1000;
constraint x3 + x4 <= 800;

% Contract/requirement constraints (avoid fractions by multiplying through)
% (1/2)x1 + (1/4)x2 >= 300  ->  2*x1 + x2 >= 1200
constraint 2*x1 + x2 >= 1200;

% (3/4)x3 + (3/5)x4 >= 250  ->  15*x3 + 12*x4 >= 5000
constraint 15*x3 + 12*x4 >= 5000;

% Objective: minimize total cost (given rates per unit)
var int: total_cost = 4*x1 + 3*x2 + 5*x3 + 6*x4;

solve minimize total_cost;

output [
  "x1=", show(x1), " x2=", show(x2), " x3=", show(x3), " x4=", show(x4), "\n",
  "Minimum total cost (rounded) = ", show(total_cost), "\n"
];