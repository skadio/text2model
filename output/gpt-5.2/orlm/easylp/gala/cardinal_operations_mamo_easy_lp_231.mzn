% Crop planning - minimize cost with acreage constraints (integers)

int: max_acres = 1000;

int: minX = 200;
int: minY = 150;
int: minZ = 100;

int: costX = 10;
int: costY = 20;
int: costZ = 30;

% Decision variables: whole acres planted
var minX..max_acres: acresX;
var minY..max_acres: acresY;
var minZ..max_acres: acresZ;

% Land limit
constraint acresX + acresY + acresZ <= max_acres;

% Total cost (in dollars)
var int: total_cost = costX * acresX + costY * acresY + costZ * acresZ;

solve minimize total_cost;

output [
  "Acres X = ", show(acresX), "\n",
  "Acres Y = ", show(acresY), "\n",
  "Acres Z = ", show(acresZ), "\n",
  "Minimum cost ($) = ", show(total_cost), "\n"
];