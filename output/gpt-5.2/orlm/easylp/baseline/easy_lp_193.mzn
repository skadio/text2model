% Fleet allocation across routes X, Y, Z
% Minimize total cost subject to minimum demands and total fleet limit.

int: max_total = 1000;

int: minX = 300;
int: minY = 200;
int: minZ = 150;

int: costX = 3;
int: costY = 2;
int: costZ = 5;

var int: x; % vehicles on route X
var int: y; % vehicles on route Y
var int: z; % vehicles on route Z

constraint x >= minX;
constraint y >= minY;
constraint z >= minZ;

constraint x + y + z <= max_total;

var int: total_cost = costX * x + costY * y + costZ * z;

solve minimize total_cost;

output [
  "x=", show(x), "\n",
  "y=", show(y), "\n",
  "z=", show(z), "\n",
  "total_cost_dollars=", show(total_cost), "\n"
];