% Transportation trucks cost minimization (all data embedded)

int: minX = 300;
int: minY = 200;
int: maxTotal = 1000;

int: costX = 2;
int: costY = 3;

var minX..maxTotal: X;
var minY..maxTotal: Y;

constraint X + Y <= maxTotal;

var int: total_cost = costX * X + costY * Y;

solve minimize total_cost;

output [
  "X=", show(X), "\n",
  "Y=", show(Y), "\n",
  "min_cost=", show(total_cost), "\n"
];