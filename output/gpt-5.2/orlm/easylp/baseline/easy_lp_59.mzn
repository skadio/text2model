int: minX = 0;
int: maxX = 100;
int: minY = 0;
int: maxY = 100;

var minX..maxX: X; % Network Upgrade
var minY..maxY: Y; % Security Enhancement

constraint 3 * X + Y >= 10;
constraint 2 * X + 4 * Y <= 20;

var int: total_cost = 4 * X + 6 * Y;

solve minimize total_cost;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Minimum total cost = ", show(total_cost), "\n"
];