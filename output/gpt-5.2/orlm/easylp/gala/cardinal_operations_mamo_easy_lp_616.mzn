include "globals.mzn";

% Resource allocation variables (whole units) with given upper limits
var 0..500: X1;
var 0..300: X2;
var 0..200: X3;
var 0..400: X4;

% Constraints
constraint X1 + X2 <= 1000;
constraint 2 * X1 + X3 >= 800;

% X4 should not be less than half of X1 (integer-safe form)
constraint 2 * X4 >= X1;

% |(1/4)X3 - X2| <= 500, integer-safe form: |X3 - 4*X2| <= 2000
constraint abs(X3 - 4 * X2) <= 2000;

% Balance constraint: (X2 + X4) - (X1 + X3) = 70
constraint (X2 + X4) - (X1 + X3) = 70;

% Objective: minimize total cost
var int: total_cost = 100 * X1 + 200 * X2 + 150 * X3 + 50 * X4;
solve minimize total_cost;

output [
  "X1=", show(X1), " X2=", show(X2), " X3=", show(X3), " X4=", show(X4), "\n",
  "Total cost = $", show(total_cost), "\n"
];