% Environmental agency fund allocation optimization
% Data embedded as requested (no .dzn).

int: BUDGET = 1000;

int: costX = 50;
int: costY = 30;
int: costZ = 20;

% Decision variables: integer allocations (non-negative)
var 0..BUDGET: X;
var 0..BUDGET: Y;
var 0..BUDGET: Z;

% Constraints
constraint X + Y + Z <= BUDGET;

constraint X - 2*Y + Z >= 200;

constraint 2*X + Y - Z <= 500;

% Objective: minimize total cost
var int: totalCost = costX*X + costY*Y + costZ*Z;

solve minimize totalCost;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Z = ", show(Z), "\n",
  "Minimum total cost = ", show(totalCost), "\n"
];