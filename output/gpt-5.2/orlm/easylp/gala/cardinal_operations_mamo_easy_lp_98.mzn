include "globals.mzn";

% Data (embedded as required)
int: BUDGET_MAX = 50000;
int: RHS_MIN = 10000;

int: costX = 5000;
int: costY = 7000;

int: maxX = 40;
int: maxY = 20;

% Decision variables: number of employees trained in each group (integers)
var 0..maxX: x;   % group X participants
var 0..maxY: y;   % group Y participants

% Total cost
var 0..BUDGET_MAX: totalCost = costX * x + costY * y;

% Constraints
constraint totalCost <= BUDGET_MAX;
constraint 3 * (costX * x) - (costY * y) >= RHS_MIN;

% Objective: minimize total cost
solve minimize totalCost;

output [
  "x (group X participants) = ", show(x), "\n",
  "y (group Y participants) = ", show(y), "\n",
  "Minimum total cost ($)   = ", show(totalCost), "\n"
];