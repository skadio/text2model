% Shipping resource distribution (integer linear optimization)

% Decision variables: number of shipments of each type (nonnegative integers)
var 0..1000: x1;
var 0..1000: x2;
var 0..1000: x3;

% Constraints
constraint x1 + x2 + x3 <= 1000;
constraint 2*x1 - 3*x2 >= 200;
constraint 4*x3 - x1 <= 500;

% Objective: minimize total cost
var int: total_cost = 5*x1 + 8*x2 + 6*x3;
solve minimize total_cost;

output [
  "x1 = ", show(x1), "\n",
  "x2 = ", show(x2), "\n",
  "x3 = ", show(x3), "\n",
  "minimum_total_cost = $", show(total_cost), "\n"
];