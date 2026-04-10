% Budget allocation between two departments X and Y
% Data embedded as requested.

int: minBudgetX = 200;
int: minBudgetY = 100;
int: maxTotalBudget = 1000;

int: unitCostX = 50;
int: unitCostY = 80;

% Decision variables: integer "units" allocated to each department
% Budget constraints are imposed via unit costs.
var 0..(maxTotalBudget div unitCostX): xUnits;
var 0..(maxTotalBudget div unitCostY): yUnits;

% Total cost (also equals total budget spend here)
var 0..maxTotalBudget: totalCost = unitCostX * xUnits + unitCostY * yUnits;

constraint unitCostX * xUnits >= minBudgetX;
constraint unitCostY * yUnits >= minBudgetY;
constraint totalCost <= maxTotalBudget;

solve minimize totalCost;

output [
  "xUnits = ", show(xUnits), "\n",
  "yUnits = ", show(yUnits), "\n",
  "totalCost = ", show(totalCost), "\n"
];