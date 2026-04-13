% Construction planning: minimize cost with integer numbers of buildings

int: costX = 50;
int: costY = 70;

int: contribX = 5;
int: contribY = 10;

int: required_total = 100;
int: max_buildings = 20;

var 0..max_buildings: X;
var 0..max_buildings: Y;

constraint contribX * X + contribY * Y >= required_total;
constraint X + Y <= max_buildings;

var int: total_cost = costX * X + costY * Y;

solve minimize total_cost;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "total_cost = $", show(total_cost), "\n"
];