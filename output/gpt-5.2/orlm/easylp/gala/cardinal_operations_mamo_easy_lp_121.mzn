include "globals.mzn";

% Parameters (embedded from problem statement)
int: maxBudget = 1000;         % X + Y <= 1000
int: minEffect = 500;          % 2X + Y >= 500
int: maxDiff = 200;            % |X - Y| <= 200

int: costX = 500;              % cost per unit for campaign X
int: costY = 300;              % cost per unit for campaign Y

% Decision variables (integers, nonnegative budgets)
var 0..maxBudget: X;
var 0..maxBudget: Y;

% Constraints
constraint X + Y <= maxBudget;
constraint 2 * X + Y >= minEffect;
constraint abs(X - Y) <= maxDiff;

% Objective: minimize total cost in dollars
var int: total_cost = costX * X + costY * Y;
solve minimize total_cost;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Total cost (USD) = ", show(total_cost), "\n"
];