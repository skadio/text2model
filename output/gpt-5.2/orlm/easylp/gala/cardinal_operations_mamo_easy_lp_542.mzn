include "globals.mzn";

% Data (embedded as requested)
int: maxTotal = 100;

int: xMin = 0;  int: xMax = 50;
int: yMin = 0;  int: yMax = 60;
int: zMin = 0;  int: zMax = 70;

int: costX = 1000;
int: costY = 2000;
int: costZ = 3000;

% Decision variables: integer resource allocations
var xMin..xMax: x;
var yMin..yMax: y;
var zMin..zMax: z;

% Constraints
constraint x + y + z <= maxTotal;
constraint 2 * x + y >= 30;
constraint x + z >= 40;

% Objective: minimize total cost
var int: totalCost = costX * x + costY * y + costZ * z;

solve minimize totalCost;

output [
  "x = ", show(x), "\n",
  "y = ", show(y), "\n",
  "z = ", show(z), "\n",
  "minimum_total_cost = $", show(totalCost), "\n"
];