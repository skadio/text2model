% Fleet distribution / route allocation (all data embedded)

% Decision variables: number of vehicles on each route (integers)
var 0..50: x1;
var 0..40: x2;
var 0..60: x3;
var 0..70: x4;

% Constraints
constraint x1 + x2 <= 20;
constraint x3 + x4 <= 30;
constraint x1 + x3 >= 15;
constraint x2 + x4 >= 10;

% Objective: minimize total operational cost
var int: total_cost = 5*x1 + 4*x2 + 6*x3 + 7*x4;

solve minimize total_cost;

output [
  "x1 = ", show(x1), "\n",
  "x2 = ", show(x2), "\n",
  "x3 = ", show(x3), "\n",
  "x4 = ", show(x4), "\n",
  "Minimum total cost (rounded) = ", show(total_cost), "\n"
];