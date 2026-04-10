include "globals.mzn";

% Investment decision variables (whole dollars)
var 200..5000: X;     % portfolio X: min 200, max 5000
var 100..4000: Y;     % portfolio Y: min 100, max 4000
var 800..10000: Z;    % portfolio Z: min 800, (upper bound limited by total budget)

% Total budget constraint
constraint X + Y + Z <= 10000;

% Return/non-negativity constraint:
% 0.07*X - 0.02*Y - 0.05*Z >= 0
% Multiply by 100 to keep it integer: 7X - 2Y - 5Z >= 0
constraint 7*X - 2*Y - 5*Z >= 0;

% Difference constraint:
% X - 2Y + Z >= 3000
constraint X - 2*Y + Z >= 3000;

% Objective: minimize total cost (fees per dollar invested)
var int: total_cost = 50*X + 30*Y + 20*Z;

solve minimize total_cost;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Z = ", show(Z), "\n",
  "Total cost = ", show(total_cost), "\n"
];