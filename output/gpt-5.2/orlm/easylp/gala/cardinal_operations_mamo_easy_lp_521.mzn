include "globals.mzn";

% Investment options: X, Y, Z are whole-number unit allocations
var 0..20: X;
var 0..20: Y;
var 0..20: Z;

% Costs per unit
int: cX = 7;
int: cY = 3;
int: cZ = 5;

% Constraints
constraint 2*X + Y + Z >= 10;              % diversification minimum
constraint X - Y + 2*Z <= 15;              % risk exposure limit
constraint X = Y + 3;                      % X always 3 more than Y
constraint X + Y + Z <= 20;                % budget limit

% Objective: minimize total cost
var int: totalCost = cX*X + cY*Y + cZ*Z;

solve minimize totalCost;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Z = ", show(Z), "\n",
  "Minimum cost (rounded) = ", show(totalCost), "\n"
];