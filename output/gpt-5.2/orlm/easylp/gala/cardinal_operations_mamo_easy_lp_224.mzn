% Telecommunications resource allocation (integer optimization)
% Data embedded as required.

int: BUDGET = 1000;

int: min_rule1 = 500;     % 2X + Y >= 500
int: max_rule2 = 800;     % X + 3Z <= 800

int: costX = 10;
int: costY = 15;
int: costZ = 20;

% Decision variables: whole-number resource units
var 0..BUDGET: X;
var 0..BUDGET: Y;
var 0..BUDGET: Z;

% Constraints
constraint X + Y + Z <= BUDGET;
constraint 2*X + Y >= min_rule1;
constraint X + 3*Z <= max_rule2;

% Objective: minimize total cost
var int: totalCost = costX*X + costY*Y + costZ*Z;
solve minimize totalCost;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Z = ", show(Z), "\n",
  "TotalCost = ", show(totalCost), "\n"
];