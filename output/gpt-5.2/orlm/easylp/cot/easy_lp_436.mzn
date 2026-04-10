% Parameters (with values embedded)
int: minBudgetX = 200;
int: minBudgetY = 100;
int: maxTotalBudget = 1000;
int: unitCostX = 50;
int: unitCostY = 80;

% Variables
var 0..maxTotalBudget: x;  % budget allocated to department X (integer dollars)
var 0..maxTotalBudget: y;  % budget allocated to department Y (integer dollars)
var 0..(unitCostX*maxTotalBudget + unitCostY*maxTotalBudget): total_cost;

% Constraints
constraint x >= minBudgetX;
constraint y >= minBudgetY;
constraint x + y <= maxTotalBudget;

constraint total_cost = unitCostX * x + unitCostY * y;

% Objective
solve minimize total_cost;