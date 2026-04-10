int: max_vessels = 100;
int: min_capacity = 50;
int: max_diff = 20;

int: costX = 3;
int: costY = 2;

var 0..max_vessels: X;
var 0..max_vessels: Y;

constraint X + Y <= max_vessels;
constraint 2 * X + 3 * Y >= min_capacity;
constraint abs(X - Y) <= max_diff;

var int: total_cost = costX * X + costY * Y;

solve minimize total_cost;

output [
  "X=", show(X), "\n",
  "Y=", show(Y), "\n",
  "total_cost=", show(total_cost), "\n"
];