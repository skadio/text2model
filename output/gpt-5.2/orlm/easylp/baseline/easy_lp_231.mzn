% Crop planning cost minimization (all data embedded)

int: max_acres = 1000;

int: minX = 200;
int: minY = 150;
int: minZ = 100;

int: costX = 10;
int: costY = 20;
int: costZ = 30;

var int: x; % acres of crop X
var int: y; % acres of crop Y
var int: z; % acres of crop Z

constraint x >= minX;
constraint y >= minY;
constraint z >= minZ;

constraint x + y + z <= max_acres;

var int: total_cost = costX * x + costY * y + costZ * z;

solve minimize total_cost;

output [
  "x=", show(x), " y=", show(y), " z=", show(z), "\n",
  "total_acres=", show(x + y + z), "\n",
  "min_cost_dollars=", show(total_cost), "\n"
];