% Investment allocation with minimum transaction costs

include "float.mzn";

var int: X; % dollars in option X
var int: Y; % dollars in option Y

constraint X >= 5000;
constraint Y >= 2000;
constraint X + Y <= 10000;

% Interest constraint: 0.07*X + 0.08*Y >= 700
% Multiply by 100 to keep integer arithmetic: 7*X + 8*Y >= 70000
constraint 7 * X + 8 * Y >= 70000;

% Objective (in cents) to avoid floating error:
% cost = 0.01*X + 0.02*Y dollars
% in cents: X + 2Y
var int: cost_cents = X + 2 * Y;

solve minimize cost_cents;

% Output minimum total transaction cost rounded to two decimals
output [
  show_float(float(cost_cents) / 100.0, 2)
];