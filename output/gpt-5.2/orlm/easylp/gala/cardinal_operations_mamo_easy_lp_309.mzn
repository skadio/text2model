include "globals.mzn";

% Decision variables: number of units deployed (must be whole numbers)
var 0..100: X;
var 0..100: Y;
var 0..100: Z;

% Constraints
constraint X + Y + Z <= 100;        % total resources limit
constraint 2*X + Y >= 50;           % strategic requirement 1
constraint X + Z >= 40;             % strategic requirement 2

% Costs (in dollars per unit)
int: costX = 5000;
int: costY = 4000;
int: costZ = 6000;

% Objective: minimize total cost
var int: totalCost = costX*X + costY*Y + costZ*Z;

solve minimize totalCost;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Z = ", show(Z), "\n",
  "Minimum total cost = $", show(totalCost), "\n"
];