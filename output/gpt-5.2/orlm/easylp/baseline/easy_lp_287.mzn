int: budget_max = 300;

int: min_X = 80;
int: min_Y = 60;
int: min_Z = 40;

int: cost_X = 50;
int: cost_Y = 70;
int: cost_Z = 100;

var int: X;
var int: Y;
var int: Z;

constraint X >= min_X;
constraint Y >= min_Y;
constraint Z >= min_Z;

constraint X + Y + Z <= budget_max;

var int: total_cost = cost_X * X + cost_Y * Y + cost_Z * Z;

solve minimize total_cost;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Z = ", show(Z), "\n",
  "Minimum total cost (rounded) = ", show(total_cost), "\n"
];