int: max_total_resources = 100;

int: costX = 5000;
int: costY = 4000;
int: costZ = 3000;

var 0..max_total_resources: X;
var 0..max_total_resources: Y;
var 0..max_total_resources: Z;

constraint X + Y + Z <= max_total_resources;
constraint 2*X + 3*Y >= 50;
constraint abs(X - Z) <= 20;

var int: total_cost = costX*X + costY*Y + costZ*Z;

solve minimize total_cost;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Z = ", show(Z), "\n",
  "Minimum total cost = $", show(total_cost), "\n"
];