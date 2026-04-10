% Manufacturing production planning: minimize cost with linear constraints
% All data embedded as requested.

include "globals.mzn";

% Parameters
int: costX = 50;
int: costY = 60;

int: capRHS = 500;     % X + 2Y <= 500
int: demRHS = 200;     % 3X + Y >= 200
int: balance = 100;    % |X - Y| <= 100

% Decision variables (whole numbers)
% Upper bounds chosen safely from constraints:
% From X + 2Y <= 500 => X <= 500, Y <= 250.
var 0..500: X;
var 0..250: Y;

% Constraints
constraint X + 2 * Y <= capRHS;
constraint 3 * X + Y >= demRHS;
constraint abs(X - Y) <= balance;

% Objective: minimize total cost
var int: totalCost = costX * X + costY * Y;

solve minimize totalCost;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "TotalCost = ", show(totalCost), "\n"
];