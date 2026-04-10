% Budget allocation across three projects X, Y, Z (all data embedded)

% Decision variables: dollars allocated to each project (whole dollars)
var 0..5000: X;
var 0..5000: Y;
var 0..5000: Z;

% Total investment cannot exceed $5000
constraint X + Y + Z <= 5000;

% Project viability / regulatory constraints
constraint X >= 1000;
constraint Y <= 3000;
constraint Z >= 500;

% Costs per dollar invested:
% X costs $100 per unit, Y costs $200 per unit, Z costs $50 per unit.
% Since allocations are in whole dollars, interpret "unit" as $1 invested.
var int: total_cost = 100 * X + 200 * Y + 50 * Z;

solve minimize total_cost;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Z = ", show(Z), "\n",
  "Total investment = ", show(X+Y+Z), "\n",
  "Minimum total cost = ", show(total_cost), "\n"
];