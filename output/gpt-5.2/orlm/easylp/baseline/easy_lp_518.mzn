% Transportation planning: allocate vehicles to routes X, Y, Z to minimize cost.

int: totalVehicles = 1000;

int: capX = 500;
int: capY = 300;
int: capZ = 200;

int: costX = 10;
int: costY = 20;
int: costZ = 30;

var 0..capX: X;
var 0..capY: Y;
var 0..capZ: Z;

constraint X + Y + Z <= totalVehicles;

% Route X requires at least 200 more vehicles than route Y
constraint X >= Y + 200;

% Difference between Y and Z cannot exceed 150
constraint abs(Y - Z) <= 150;

var int: totalCost = costX * X + costY * Y + costZ * Z;

solve minimize totalCost;

output [
  "X=", show(X), "\n",
  "Y=", show(Y), "\n",
  "Z=", show(Z), "\n",
  "totalCost=", show(totalCost), "\n",
  "min_total_operating_cost_rounded=", show(totalCost), "\n"
];