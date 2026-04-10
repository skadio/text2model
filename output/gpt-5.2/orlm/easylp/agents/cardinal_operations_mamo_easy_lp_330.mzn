% Parameters
% Maximum combined budgets
int: maxXY = 100;
int: maxZW = 200;

% Minimum combined budgets (reach constraints)
int: minXZ = 50;
int: minYW = 70;

% Cost per unit effectiveness (dollars per unit budget)
int: costX = 10;
int: costY = 15;
int: costZ = 25;
int: costW = 30;

% Variables
% Integer budget allocations per channel (non-negative; bounded by group maxima)
var 0..maxXY: budgetX;
var 0..maxXY: budgetY;
var 0..maxZW: budgetZ;
var 0..maxZW: budgetW;

% Total cost to minimize (safe upper bound from variable domains)
var 0..(costX*maxXY + costY*maxXY + costZ*maxZW + costW*maxZW): totalCost;

% Constraints
% Budget cap constraints (maximum combined budgets)
constraint budgetX + budgetY <= maxXY;
constraint budgetZ + budgetW <= maxZW;

% Reach constraints (minimum combined budgets to satisfy outreach targets)
constraint budgetX + budgetZ >= minXZ;
constraint budgetY + budgetW >= minYW;

% Total cost definition (link totalCost to individual channel budgets and unit costs)
constraint totalCost = costX*budgetX + costY*budgetY + costZ*budgetZ + costW*budgetW;

% Objective
solve minimize totalCost;