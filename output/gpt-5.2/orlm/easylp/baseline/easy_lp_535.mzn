% Resource allocation for crops X, Y, Z (acres), integer areas

int: max_land = 500;

int: costX = 100;
int: costY = 50;
int: costZ = 75;

var 0..max_land: X;
var 0..max_land: Y;
var 0..max_land: Z;

% Land limitation
constraint X + Y + Z <= max_land;

% Diversity yield requirement
constraint 2 * X + Y >= 200;

% Balance between Y and Z
constraint abs(Y - Z) <= 50;

% "Area allocated to crop X must be at least twice that of half of crop Z's area by at least 100 acres."
% Interpreted as: X >= 2*(Z/2) + 100 = Z + 100
constraint X >= Z + 100;

var int: total_cost = costX * X + costY * Y + costZ * Z;

solve minimize total_cost;

output [
  "X(acres) = ", show(X), "\n",
  "Y(acres) = ", show(Y), "\n",
  "Z(acres) = ", show(Z), "\n",
  "Minimum total cost ($) = ", show(total_cost), "\n"
];