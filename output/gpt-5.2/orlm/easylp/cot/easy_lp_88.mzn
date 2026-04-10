% Parameters (with values embedded)
int: max_constraint1 = 40;
int: min_constraint2 = 30;
int: costX = 8;
int: costY = 12;

% Variables
var 0..40: X;  % hours for group X (integer, non-negative)
var 0..40: Y;  % hours for group Y (integer, non-negative)
var 0..(costX*40 + costY*40): total_cost;

% Constraints
constraint 2*X + 3*Y <= max_constraint1;
constraint 4*X + 1*Y >= min_constraint2;
constraint total_cost = costX*X + costY*Y;

% Objective
solve minimize total_cost;

output [
  "X=", show(X), " hours\n",
  "Y=", show(Y), " hours\n",
  "Minimum total cost=$", show(total_cost), "\n"
];