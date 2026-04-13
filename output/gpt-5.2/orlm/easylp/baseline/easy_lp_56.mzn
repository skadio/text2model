% Shelf space allocation for products X and Y (integers)
% Minimize total cost subject to constraints.

int: total_space = 2000;
int: demand_min = 500;
int: diff_max = 1000;

int: costX = 2;
int: costY = 3;

var 0..total_space: X;
var 0..total_space: Y;

constraint X + Y <= total_space;
constraint 2*X + Y >= demand_min;
constraint abs(X - 2*Y) <= diff_max;

var int: total_cost = costX * X + costY * Y;

solve minimize total_cost;

output [
  "X=", show(X), "\n",
  "Y=", show(Y), "\n",
  "min_cost_dollars=", show(total_cost), "\n"
];