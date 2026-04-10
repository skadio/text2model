% Resource allocation for projects X, Y, Z (integers)
% Minimize total cost subject to given constraints.

int: total_resources = 100;

int: costX = 50;
int: costY = 30;
int: costZ = 20;

var 0..total_resources: X;
var 0..total_resources: Y;
var 0..total_resources: Z;

constraint X + Y + Z <= total_resources;
constraint 2 * X + Y >= 50;
constraint X + Z <= 70;

var int: total_cost = costX * X + costY * Y + costZ * Z;

solve minimize total_cost;

output [
  "X=", show(X), "\n",
  "Y=", show(Y), "\n",
  "Z=", show(Z), "\n",
  "min_total_cost=", show(total_cost), "\n"
];