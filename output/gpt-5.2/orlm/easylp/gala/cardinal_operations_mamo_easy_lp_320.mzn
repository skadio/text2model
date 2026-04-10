% Vehicle allocation across routes X, Y, Z with minimum cost

% Embedded data (from problem description)
int: maxFleet = 1000;

int: minX = 200;
int: minY = 150;
int: minZ = 300;

int: costX = 5;
int: costY = 4;
int: costZ = 6;

% Decision variables: number of vehicles assigned to each route (integers)
var minX..maxFleet: x;
var minY..maxFleet: y;
var minZ..maxFleet: z;

% Fleet limit
constraint x + y + z <= maxFleet;

% Total cost
var int: totalCost = costX * x + costY * y + costZ * z;

solve minimize totalCost;

output [
  "x = ", show(x), "\n",
  "y = ", show(y), "\n",
  "z = ", show(z), "\n",
  "totalCost = ", show(totalCost), "\n"
];