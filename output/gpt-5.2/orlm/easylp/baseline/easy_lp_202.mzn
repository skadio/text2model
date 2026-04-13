% Fund allocation problem with embedded data

int: BUDGET = 5000;

int: costX = 10;
int: costY = 15;
int: costZ = 20;

int: minGapXY = 1000;  % X >= 2*Y + 1000
int: minGapZY = 1500;  % Z >= Y + 1500

var 0..BUDGET: X;
var 0..BUDGET: Y;
var 0..BUDGET: Z;

constraint X + Y + Z <= BUDGET;
constraint X >= 2 * Y + minGapXY;
constraint Z >= Y + minGapZY;

var int: total_cost = costX * X + costY * Y + costZ * Z;

solve minimize total_cost;

output [
  "X=", show(X), "\n",
  "Y=", show(Y), "\n",
  "Z=", show(Z), "\n",
  "TotalCost=", show(total_cost), "\n"
];