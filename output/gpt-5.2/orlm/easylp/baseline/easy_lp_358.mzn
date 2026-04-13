% Fund allocation problem (all data embedded)

int: cost1 = 2;
int: cost2 = 3;
int: cost3 = 4;
int: cost4 = 5;

% Bounds (not explicitly specified in the description; choose safe nonnegative bounds)
int: UB = 10000;

var 0..UB: X1;
var 0..UB: X2;
var 0..UB: X3;
var 0..UB: X4;

% Constraints
constraint X1 + X2 <= 2000;
constraint 2 * X3 + 3 * X4 >= 3000;
constraint abs(X1 - X4) <= 500;
constraint X2 >= X3 + 1000;

% Objective: minimize total expenditure
var int: total_cost = cost1 * X1 + cost2 * X2 + cost3 * X3 + cost4 * X4;
solve minimize total_cost;

output [
  "X1=", show(X1), "\n",
  "X2=", show(X2), "\n",
  "X3=", show(X3), "\n",
  "X4=", show(X4), "\n",
  "Minimum total expenditure=", show(total_cost), "\n"
];