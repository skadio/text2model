int: total_employees = 100;

int: min_X = 20;
int: min_Y = 15;
int: min_Z = 10;

int: cost_X = 50;
int: cost_Y = 80;
int: cost_Z = 30;

var int: X;
var int: Y;
var int: Z;

constraint X + Y + Z = total_employees;
constraint X >= min_X;
constraint Y >= min_Y;
constraint Z >= min_Z;

var int: total_cost = cost_X * X + cost_Y * Y + cost_Z * Z;

solve minimize total_cost;

output [
  "X=", show(X), "\n",
  "Y=", show(Y), "\n",
  "Z=", show(Z), "\n",
  "minimum_total_cost_dollars=", show(total_cost), "\n"
];