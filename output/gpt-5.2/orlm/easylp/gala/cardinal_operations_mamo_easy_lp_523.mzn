include "globals.mzn";

% Decision variables (integer allocations)
var 0..100: X1; % surgery
var 0..100: X2; % internal medicine
var 0..100: X3; % diagnostics

% Bounds / total budget
constraint X1 + X2 + X3 <= 100;

% Constraints:
% 2*X1 must exceed (1/2)*X2 by at least 30:
% 2*X1 >= 0.5*X2 + 30  -> multiply by 2: 4*X1 - X2 >= 60
constraint 4 * X1 - X2 >= 60;

% X1 - 0.5*X3 <= 20  -> multiply by 2: 2*X1 - X3 <= 40
constraint 2 * X1 - X3 <= 40;

% Objective: minimize total cost.
% Costs: 0.5, 0.3, 0.7 dollars/unit.
% Use scaled-by-10 integer objective to avoid floats: 5,3,7 tenths of dollars.
var 0..7000: cost10;
constraint cost10 = 5 * X1 + 3 * X2 + 7 * X3;

solve minimize cost10;

output [
  "X1 = ", show(X1), "\n",
  "X2 = ", show(X2), "\n",
  "X3 = ", show(X3), "\n",
  "MinCost($) = ", show(cost10 div 10), ".", show(cost10 mod 10), "\n"
];