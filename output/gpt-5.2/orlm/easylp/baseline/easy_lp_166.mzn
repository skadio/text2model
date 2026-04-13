% Resource allocation for promotional channels X, Y, Z
% Minimize total cost subject to given constraints.

var 0..1000: X;
var 0..1000: Y;
var 0..1000: Z;

% Total resources cannot exceed 1000
constraint X + Y + Z <= 1000;

% Channel X requires at least twice as many resources as channel Y,
% with a combined minimum of 200 units
constraint X >= 2 * Y;
constraint X + Y >= 200;

% Allocation for channel Y and twice allocation for channel Z
% should reach a minimum of 300 units
constraint Y + 2 * Z >= 300;

% Objective: minimize total cost in dollars
var int: total_cost = 10 * X + 15 * Y + 20 * Z;

solve minimize total_cost;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Z = ", show(Z), "\n",
  "Total cost ($) = ", show(total_cost), "\n"
];