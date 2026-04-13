include "globals.mzn";

% Data (embedded from the problem statement)
int: costLabor = 5;
int: costMaterial = 3;
int: costEquipment = 2;

int: maxBudgetExpr = 1000;   % 4*labor + material <= 1000
int: minStrengthExpr = 500;  % 2*labor + 3*equipment >= 500
int: diffME = 100;           % material - equipment = 100

% Decision variables (nonnegative whole numbers)
var 0..10000: labor;
var 0..10000: material;
var 0..10000: equipment;

% Constraints
constraint 4 * labor + material <= maxBudgetExpr;
constraint 2 * labor + 3 * equipment >= minStrengthExpr;
constraint material - equipment = diffME;

% Objective: minimize total cost
var 0..intmax: totalCost = costLabor * labor + costMaterial * material + costEquipment * equipment;

solve minimize totalCost;

output [
  "labor = ", show(labor), "\n",
  "material = ", show(material), "\n",
  "equipment = ", show(equipment), "\n",
  "minimum_total_cost = ", show(totalCost), "\n"
];