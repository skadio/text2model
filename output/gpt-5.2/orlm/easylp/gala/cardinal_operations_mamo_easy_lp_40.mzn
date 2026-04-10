% Finance manager investment allocation (amounts in thousands of dollars, integers)

% Data (embedded from problem statement)
int: minX = 10;          % $10,000
int: minY = 5;           % $5,000
int: minTotal = 20;      % $20,000
int: maxReturnBudget = 5000; % constraint on 3*X + 4*Y (in thousands)
int: retX = 3;
int: retY = 4;
int: costPerUnitRetX = 100;  % $ per unit of return
int: costPerUnitRetY = 200;  % $ per unit of return

% Decision variables: investments (in thousands of dollars)
var minX..maxReturnBudget: X;
var minY..maxReturnBudget: Y;

% Constraints
constraint X + Y >= minTotal;
constraint retX * X + retY * Y <= maxReturnBudget;

% Objective: minimize total cost ($)
% Return units are (retX*X + retY*Y) where X,Y are in thousands.
% Each "unit of return" corresponds to 1 (thousand-dollar) unit as used in constraints.
var int: totalCost =
    costPerUnitRetX * retX * X + costPerUnitRetY * retY * Y;

solve minimize totalCost;

output [
  "X (thousand $) = ", show(X), "\n",
  "Y (thousand $) = ", show(Y), "\n",
  "ReturnBudgetUsed = ", show(retX*X + retY*Y), " (thousand-units)\n",
  "Minimum total cost ($) = ", show(totalCost), "\n"
];