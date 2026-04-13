% Marketing budget allocation: minimize total cost subject to constraints
% All data embedded; integer budgets required.

int: BUDGET_MAX = 5000;

int: costX = 60;
int: costY = 75;
int: costZ = 50;

var 0..BUDGET_MAX: X;
var 0..BUDGET_MAX: Y;
var 0..BUDGET_MAX: Z;

constraint X + Y + Z <= BUDGET_MAX;

% Effectiveness constraints (as given)
constraint 3*X - Y + Z >= 2000;
constraint X - 2*Y + Z >= -1000;   % Equivalent to: X - 2Y + Z >= -1000
constraint X - Y + 3*Z >= 1500;

var int: total_cost = costX*X + costY*Y + costZ*Z;

solve minimize total_cost;

output [
  "X=", show(X), "\n",
  "Y=", show(Y), "\n",
  "Z=", show(Z), "\n",
  "TotalCost=", show(total_cost), "\n"
];