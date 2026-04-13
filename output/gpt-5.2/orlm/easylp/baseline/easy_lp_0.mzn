% Resource allocation: minimize total cost subject to constraints.
% Data embedded directly.

int: budget = 1000;
int: min_excess = 200;

int: costX = 50;
int: costY = 30;

int: maxX = 700;
int: maxY = 500;

var 0..maxX: X;
var 0..maxY: Y;

constraint X + Y <= budget;
constraint X >= Y + min_excess;

var int: total_cost = costX * X + costY * Y;

solve minimize total_cost;

output [
  "X=", show(X), "\n",
  "Y=", show(Y), "\n",
  "min_cost_dollars=", show(total_cost), "\n"
];