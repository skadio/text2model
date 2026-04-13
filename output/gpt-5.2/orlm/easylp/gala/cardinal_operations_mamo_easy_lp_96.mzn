% Supply chain resource allocation (integer linear optimization)

% Decision variables (resource units)
var 0..100: X;  % sourcing
var 0..100: Y;  % distribution

% Constraints
constraint X + Y <= 100;
constraint 2*X + Y >= 50;
constraint abs(X - Y) <= 30;

% Objective: minimize total cost
var 0..500: total_cost;
constraint total_cost = 2*X + 3*Y;

solve minimize total_cost;

output [
  "X (sourcing) = ", show(X), "\n",
  "Y (distribution) = ", show(Y), "\n",
  "Minimum total cost ($) = ", show(total_cost), "\n"
];