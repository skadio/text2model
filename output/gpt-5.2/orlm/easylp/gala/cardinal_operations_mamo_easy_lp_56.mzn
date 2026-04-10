% Shelf space allocation for products X and Y (integers), minimize cost.

% Decision variables (units of shelf space, nonnegative integers)
var 0..2000: x;
var 0..2000: y;

% Constraints
constraint x + y <= 2000;                 % total shelf space limit
constraint 2*x + y >= 500;                % demand constraint
constraint abs(x - 2*y) <= 1000;          % balance constraint

% Objective: minimize total cost ($2 per unit of X, $3 per unit of Y)
var int: total_cost = 2*x + 3*y;

solve minimize total_cost;

output [
  "x = ", show(x), "\n",
  "y = ", show(y), "\n",
  "minimum_total_cost = $", show(total_cost), "\n"
];