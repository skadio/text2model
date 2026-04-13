% Resource allocation for hospital departments X, Y, Z
% Minimize total cost subject to constraints.

int: total_capacity = 150;

int: costX = 100;
int: costY = 50;
int: costZ = 30;

var 0..total_capacity: X;
var 0..total_capacity: Y;
var 0..total_capacity: Z;

constraint X + Y + Z <= total_capacity;
constraint X >= Y + 10;
constraint Y <= Z + 20;

var int: total_cost = costX * X + costY * Y + costZ * Z;

solve minimize total_cost;

output [
  "X=", show(X), "\n",
  "Y=", show(Y), "\n",
  "Z=", show(Z), "\n",
  "TotalCost=", show(total_cost), "\n"
];