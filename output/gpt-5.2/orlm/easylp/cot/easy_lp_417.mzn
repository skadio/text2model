% Parameters (with values embedded)
int: maxBudget = 5000;
int: minEffectPoints = 2000;
int: maxDiff = 1000;

int: costX = 1000;
int: costY = 1500;

% Variables
var 0..maxBudget: x;  % budget allocated to channel X (integer dollars)
var 0..maxBudget: y;  % budget allocated to channel Y (integer dollars)

% Constraints
constraint x + y <= maxBudget;
constraint 3 * x - 2 * y >= minEffectPoints;
constraint x - y <= maxDiff;

% Objective
var int: totalCost = costX * x + costY * y;
solve minimize totalCost;