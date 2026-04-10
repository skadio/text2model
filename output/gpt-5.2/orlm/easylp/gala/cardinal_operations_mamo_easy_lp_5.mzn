% Budget allocation between two advertising channels

% Data (embedded as requested)
int: maxBudget = 1000;          % X + Y <= 1000
int: minEffect = 2000;          % 2X + 3Y >= 2000

int: effX = 2;
int: effY = 3;

int: costX = 10;                % $ per unit budget for X
int: costY = 20;                % $ per unit budget for Y

% Decision variables (integer budget units)
var 0..maxBudget: X;
var 0..maxBudget: Y;

% Constraints
constraint X + Y <= maxBudget;
constraint effX * X + effY * Y >= minEffect;

% Objective: minimize total cost
var 0..(costX*maxBudget + costY*maxBudget): totalCost = costX*X + costY*Y;
solve minimize totalCost;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Minimum total cost ($) = ", show(totalCost), "\n"
];