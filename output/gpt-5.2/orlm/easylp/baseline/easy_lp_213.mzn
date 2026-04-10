% Resource allocation among programs X, Y, Z (all integer allocations)

int: total_capacity = 100;

int: min_X = 10;
int: min_Y = 20;
int: min_Z = 15;

int: cost_X = 30;
int: cost_Y = 20;
int: cost_Z = 50;

var int: X;
var int: Y;
var int: Z;

constraint X >= min_X;
constraint Y >= min_Y;
constraint Z >= min_Z;

constraint X + Y + Z <= total_capacity;

var int: total_cost = cost_X * X + cost_Y * Y + cost_Z * Z;

solve minimize total_cost;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Z = ", show(Z), "\n",
  "Total cost ($) = ", show(total_cost), "\n"
];