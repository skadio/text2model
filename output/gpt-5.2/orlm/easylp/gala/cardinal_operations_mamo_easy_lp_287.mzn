include "globals.mzn";

% Data (embedded as required)
int: budgetMax = 300;

int: minX = 80;
int: minY = 60;
int: minZ = 40;

int: costX = 50;
int: costY = 70;
int: costZ = 100;

% Decision variables: whole-number investment amounts in each project
var minX..budgetMax: x;
var minY..budgetMax: y;
var minZ..budgetMax: z;

% Budget constraint
constraint x + y + z <= budgetMax;

% Objective: minimize total cost
var int: totalCost = costX*x + costY*y + costZ*z;

solve minimize totalCost;

output [
  "x = ", show(x), "\n",
  "y = ", show(y), "\n",
  "z = ", show(z), "\n",
  "totalCost = ", show(totalCost), "\n",
  "rounded_totalCost = ", show(totalCost), "\n"
];