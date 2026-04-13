include "globals.mzn";

% Decision variables (whole numbers)
var 0..599: x1;   % manufacturing: less than 600
var 0..500: x2;   % distribution: at most 500
var 0..299: x3;   % retail: less than 300

% Objective: minimize total operational cost
var int: total_cost = 2*x1 + 3*x2 + 4*x3;

% Constraints
constraint x1 + x2 + x3 <= 1000;

% 5*x1 - 0.5*x2 >= 500  <=>  10*x1 - x2 >= 1000
constraint 10*x1 - x2 >= 1000;

% 4.5*x3 - x1 <= 450  <=>  9*x3 - 2*x1 <= 900
constraint 9*x3 - 2*x1 <= 900;

% x2 + 0.5*x3 - x1 >= 200  <=>  2*x2 + x3 - 2*x1 >= 400
constraint 2*x2 + x3 - 2*x1 >= 400;

solve minimize total_cost;

output [
  "x1(manufacturing) = ", show(x1), "\n",
  "x2(distribution)  = ", show(x2), "\n",
  "x3(retail)        = ", show(x3), "\n",
  "Minimum cost ($)  = ", show(total_cost), "\n"
];