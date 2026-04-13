% Tourism tour planning: minimize total cost with integer numbers of tours.

int: max_total_groups = 20;
int: min_diversity = 10;          % 2*X + Y >= 10
int: max_diff = 5;               % |X - Y| <= 5

int: maxX = 15;
int: maxY = 10;

int: costX = 100;
int: costY = 50;

var 0..maxX: X;
var 0..maxY: Y;

constraint X + Y <= max_total_groups;
constraint 2*X + Y >= min_diversity;
constraint abs(X - Y) <= max_diff;

var int: total_cost = costX * X + costY * Y;

solve minimize total_cost;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Minimum total cost = $", show(total_cost), "\n"
];