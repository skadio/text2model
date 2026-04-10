% Shipping company resource allocation (all data embedded)

% Costs per resource
int: costX = 5;
int: costY = 10;
int: costZ = 7;

% Availability and requirements
int: totalMax = 1000;
int: minX = 200;
int: maxY = 400;
int: minZ = 150;

% Decision variables: whole-number resources allocated to each warehouse
var minX..totalMax: x;
var 0..maxY: y;
var minZ..totalMax: z;

% Total resources limit
constraint x + y + z <= totalMax;

% Objective: minimize total cost
var int: totalCost = costX * x + costY * y + costZ * z;

solve minimize totalCost;

output [
  "x = ", show(x), "\n",
  "y = ", show(y), "\n",
  "z = ", show(z), "\n",
  "minimum total cost ($) = ", show(totalCost), "\n"
];