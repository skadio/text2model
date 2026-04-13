% Resource allocation among three departments (integer units)
% Minimize total cost subject to operational constraints.

include "globals.mzn";

% Decision variables (whole number allocations)
var 0..200: X1;
var 0..200: X2;
var 0..200: X3;

% Constraints
constraint X1 + X2 + X3 <= 200;

% Performance index: 0.5*X1 - 0.3*X2 + 0.4*X3 >= 40
% Multiply by 10 to avoid decimals: 5*X1 - 3*X2 + 4*X3 >= 400
constraint 5*X1 - 3*X2 + 4*X3 >= 400;

% Balance constraint: 2*X2 - (X1 + X3) <= 70
constraint 2*X2 - X1 - X3 <= 70;

% Objective: minimize total cost
var int: total_cost = 50*X1 + 30*X2 + 20*X3;
solve minimize total_cost;

output [
  "X1=", show(X1), " X2=", show(X2), " X3=", show(X3), "\n",
  "minimum_total_cost_rounded_up=", show(total_cost), "\n"
];