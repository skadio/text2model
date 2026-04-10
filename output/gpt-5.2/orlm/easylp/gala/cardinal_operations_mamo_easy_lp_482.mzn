% Budget allocation for two projects (all data embedded)

% Data
int: minX = 10;
int: minY = 5;
int: maxTotal = 40;

int: outcomePerX = 50;
int: outcomePerY = 30;

% Decision variables (integer budgets)
var minX..maxTotal: X;
var minY..maxTotal: Y;

% Constraints
constraint X + Y <= maxTotal;

% Objective: maximize total outcome
var int: totalOutcome = outcomePerX * X + outcomePerY * Y;

solve maximize totalOutcome;

output [
  "Budget X = $", show(X), "\n",
  "Budget Y = $", show(Y), "\n",
  "Total budget = $", show(X + Y), "\n",
  "Optimal outcome (units) = ", show(totalOutcome), "\n"
];