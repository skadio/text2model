% Marketing budget distribution optimization (all data embedded)

int: maxTotalBudget = 1000;

int: maxX = 500;
int: maxY = 400;
int: maxZ = 600;

int: costX = 100;
int: costY = 200;
int: costZ = 300;

int: diffLimit = 150;

var 0..maxX: X;
var 0..maxY: Y;
var 0..maxZ: Z;

% Total budget constraint
constraint X + Y + Z <= maxTotalBudget;

% X should not be less than half of Y: X >= Y/2  <=> 2X >= Y
constraint 2 * X >= Y;

% |Z - (3/4)X| <= 150  -> use integer form: |4Z - 3X| <= 600
constraint abs(4 * Z - 3 * X) <= 4 * diffLimit;

% Y at least 50 more than Z
constraint Y >= Z + 50;

% Objective: minimize total cost (cost per unit effectiveness)
var int: totalCost = costX * X + costY * Y + costZ * Z;

solve minimize totalCost;

output [
  "X=", show(X), "\n",
  "Y=", show(Y), "\n",
  "Z=", show(Z), "\n",
  "totalCost=", show(totalCost), "\n"
];