include "globals.mzn";

% Decision variables (integers)
var 10..100: X;  % residential properties, at least 10
var 5..100:  Y;  % commercial properties, at least 5

% Total properties cannot exceed 100
constraint X + Y <= 100;

% ROI constraint:
% 0.3*X + 0.4*Y >= 30  -> multiply by 10 to keep integer arithmetic:
constraint 3 * X + 4 * Y >= 300;

% Risk diversification constraint:
% | 0.5*X - 0.2*Y | <= 40  -> multiply by 10:
constraint abs(5 * X - 2 * Y) <= 400;

% Objective: minimize total cost
% Residential cost = 50000, Commercial cost = 70000
var int: total_cost = 50000 * X + 70000 * Y;

solve minimize total_cost;

output [
  "X (residential) = ", show(X), "\n",
  "Y (commercial)  = ", show(Y), "\n",
  "Total cost ($)  = ", show(total_cost), "\n"
];