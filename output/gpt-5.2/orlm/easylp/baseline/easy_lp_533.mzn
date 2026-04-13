int: c1 = 10;
int: c2 = 20;
int: c3 = 30;

% Bounds on allocations (not specified in the description; using nonnegative bounds)
int: UB = 2000;

var 0..UB: X1;
var 0..UB: X2;
var 0..UB: X3;

% Constraints
constraint X1 + 2*X2 <= 2000;
constraint 3*X1 + 4*X3 >= 1000;
constraint X2 - 5*X3 <= 500;

% Objective
var int: total_cost = c1*X1 + c2*X2 + c3*X3;
solve minimize total_cost;

output [
  "X1=", show(X1), "\n",
  "X2=", show(X2), "\n",
  "X3=", show(X3), "\n",
  "minimum_total_cost=$", show(total_cost), "\n"
];