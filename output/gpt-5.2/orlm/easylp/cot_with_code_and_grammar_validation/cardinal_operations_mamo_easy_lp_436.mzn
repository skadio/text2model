% Parameters
int: minBudgetX = 200;
int: minBudgetY = 100;
int: maxTotalBudget = 1000;

int: unitCostX = 50;
int: unitCostY = 80;

% Variables
var int: xUnits;
var int: yUnits;

% Constraints
constraint xUnits >= 0;
constraint yUnits >= 0;

constraint unitCostX * xUnits >= minBudgetX;
constraint unitCostY * yUnits >= minBudgetY;

constraint unitCostX * xUnits + unitCostY * yUnits <= maxTotalBudget;

% Objective
solve minimize unitCostX * xUnits + unitCostY * yUnits;