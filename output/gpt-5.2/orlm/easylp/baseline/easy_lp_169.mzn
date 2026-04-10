% Resource allocation between three advertising campaigns
% Minimize total cost given minimum allocations and total budget cap

int: BUDGET_MAX = 1000;

int: minX = 200;
int: minY = 100;
int: minZ = 50;

int: costX = 2;
int: costY = 3;
int: costZ = 4;

var int: x;
var int: y;
var int: z;

constraint x >= minX;
constraint y >= minY;
constraint z >= minZ;

constraint x + y + z <= BUDGET_MAX;

var int: total_cost = costX * x + costY * y + costZ * z;

solve minimize total_cost;

output [
  "x=", show(x), "\n",
  "y=", show(y), "\n",
  "z=", show(z), "\n",
  "total_cost=", show(total_cost), "\n"
];