% Budget allocation minimization (all data embedded)

int: maxBudget = 10000;

int: minX = 2000; % patient care
int: minY = 1500; % medical research
int: minZ = 500;  % maintenance

% Integer dollar allocations
var minX..maxBudget: X;
var minY..maxBudget: Y;
var minZ..maxBudget: Z;

% Total dollars spent (the "total cost" to minimize)
var 0..maxBudget: totalCost;

constraint X + Y + Z <= maxBudget;
constraint totalCost = X + Y + Z;

solve minimize totalCost;

output [
  "Minimum total cost ($) = ", show(totalCost), "\n",
  "X (patient care) = ", show(X), "\n",
  "Y (research) = ", show(Y), "\n",
  "Z (maintenance) = ", show(Z), "\n"
];