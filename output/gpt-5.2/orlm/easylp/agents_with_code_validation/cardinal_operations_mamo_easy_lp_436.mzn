% Parameters
% Minimum required budgets (in dollars)
int: minBudgetX = 200;
int: minBudgetY = 100;

% Maximum total budget (in dollars)
int: maxTotalBudget = 1000;

% Cost per unit allocated to each department (in dollars per unit)
int: costPerUnitX = 50;
int: costPerUnitY = 80;

% Variables
% Integer number of allocation units for each department
% (bounded using budget limits: units * costPerUnit must satisfy budget constraints)
var 0..(maxTotalBudget div costPerUnitX): unitsX; % units allocated to X
var 0..(maxTotalBudget div costPerUnitY): unitsY; % units allocated to Y

% Dollar budgets implied by the chosen units
var 0..maxTotalBudget: budgetX; % total dollars allocated to X
var 0..maxTotalBudget: budgetY; % total dollars allocated to Y

% Total cost (objective value), in dollars
var 0..maxTotalBudget: totalCost;

% Constraints
% Link unit decisions to implied dollar budgets
constraint budgetX = unitsX * costPerUnitX;
constraint budgetY = unitsY * costPerUnitY;

% Enforce minimum required budgets for each department
constraint budgetX >= minBudgetX;
constraint budgetY >= minBudgetY;

% Enforce maximum total budget limit across both departments
constraint budgetX + budgetY <= maxTotalBudget;

% Define total cost as the sum of allocated budgets
constraint totalCost = budgetX + budgetY;

% Objective
solve minimize totalCost;