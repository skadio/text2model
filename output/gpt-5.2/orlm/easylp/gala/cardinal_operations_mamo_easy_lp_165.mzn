% Marketing resource allocation (all data embedded)
% Minimize total cost subject to linear constraints and upper bounds.
include "globals.mzn";

% Decision variables (whole numbers)
var 0..30000: Advertising;
var 0..20000: Promotion;
var 0..25000: Sales;

% Constraints
constraint Advertising + Promotion >= 10000;
constraint 2 * Advertising + Sales <= 50000;
constraint Sales - Promotion >= 2000;

% Objective: minimize total cost in dollars
var int: TotalCost = 3 * Advertising + 2 * Promotion + 1 * Sales;

solve minimize TotalCost;

output [
  "Advertising = ", show(Advertising), "\n",
  "Promotion   = ", show(Promotion), "\n",
  "Sales       = ", show(Sales), "\n",
  "TotalCost   = ", show(TotalCost), "\n"
];