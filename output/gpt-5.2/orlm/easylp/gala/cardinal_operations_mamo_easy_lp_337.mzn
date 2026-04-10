include "globals.mzn";

% Product quantities (integer decision variables with given bounds)
var 0..600: X1;
var 0..500: X2;
var 0..400: X3;
var 0..300: X4;

% Constraints
constraint X1 + X2 <= 1000;                 % raw material
constraint 2*X1 + X3 <= 1500;               % machine capacity
constraint 3*X2 + 2*X4 >= 1200;             % demand requirement
constraint abs(X3 - X4) <= 500;             % balanced mix (redundant given bounds, but included)

% Objective: minimize total cost
var int: total_cost = 10*X1 + 12*X2 + 20*X3 + 15*X4;

solve minimize total_cost;

output [
  "X1=", show(X1), " X2=", show(X2), " X3=", show(X3), " X4=", show(X4), "\n",
  "Minimum total cost ($) = ", show(total_cost), "\n"
];