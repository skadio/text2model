% Marketing budget allocation: minimize total spend
% Data embedded per instructions (no .dzn).

int: maxTotalBudget = 5000;
int: minAdvantage2XoverY = 1000;   % 2X - Y >= 1000
int: maxDiffXminus3Y = 2000;       % X - 3Y <= 2000

int: costPerUnitX = 1000;
int: costPerUnitY = 1500;

% Decision variables: integer units of "effectiveness" purchased
var 0..maxTotalBudget div costPerUnitX: xUnits;
var 0..maxTotalBudget div costPerUnitY: yUnits;

% Derived dollar budgets for channels
var 0..maxTotalBudget: X = costPerUnitX * xUnits;
var 0..maxTotalBudget: Y = costPerUnitY * yUnits;

% Constraints (in dollars)
constraint X + Y <= maxTotalBudget;
constraint 2 * X - Y >= minAdvantage2XoverY;
constraint X - 3 * Y <= maxDiffXminus3Y;

% Objective: minimize total expenditure (in dollars)
var 0..maxTotalBudget: totalSpend = X + Y;
solve minimize totalSpend;

output [
  "Minimum total expenditure ($): ", show(totalSpend), "\n",
  "X units: ", show(xUnits), "  => X budget ($): ", show(X), "\n",
  "Y units: ", show(yUnits), "  => Y budget ($): ", show(Y), "\n"
];