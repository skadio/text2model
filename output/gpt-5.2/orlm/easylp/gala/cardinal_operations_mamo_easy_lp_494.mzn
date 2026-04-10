% Shipping fleet allocation (embedded data, integer decision variables)

% Decision variables: number of ships of each type
var 0..1000: x;   % type X ships
var 0..1000: y;   % type Y ships

% Constraints
constraint x + y <= 1000;
constraint 2*x + y >= 800;

% | x - (y/2) | <= 200  expressed without fractions:
% |2x - y| <= 400
constraint 2*x - y <= 400;
constraint y - 2*x <= 400;

% Objective: minimize total cost
var int: cost = 8*x + 15*y;

solve minimize cost;

output [
  "x = ", show(x), "\n",
  "y = ", show(y), "\n",
  "min_cost = ", show(cost), "\n"
];