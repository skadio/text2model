% Budget allocation across channels X, Y, Z
% Minimize total cost given minimum viable budgets and total budget cap.
% Budgets are whole dollars.

int: totalBudgetCap = 1000;

int: minX = 200;
int: minY = 150;
int: minZ = 100;

int: costPerUnitX = 50;
int: costPerUnitY = 60;
int: costPerUnitZ = 70;

var int: x; % dollars allocated to channel X
var int: y; % dollars allocated to channel Y
var int: z; % dollars allocated to channel Z

constraint x >= minX /\ y >= minY /\ z >= minZ;
constraint x + y + z <= totalBudgetCap;

% Total cost (as defined by cost per unit effectiveness times allocated units)
var int: totalCost = costPerUnitX * x + costPerUnitY * y + costPerUnitZ * z;

solve minimize totalCost;

output [
  "x=", show(x), "\n",
  "y=", show(y), "\n",
  "z=", show(z), "\n",
  "totalBudget=", show(x+y+z), "\n",
  "minimumTotalCost=", show(totalCost), "\n"
];