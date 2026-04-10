% Tourism company resource allocation (embed all data here)

% Parameters
int: max_total = 200;
int: min_X = 50;
int: min_Y = 30;
int: cost_X = 300;
int: cost_Y = 500;

% Decision variables (integers)
var min_X..max_total: X;   % local sightseeing tours
var min_Y..max_total: Y;   % adventure activities

% Constraints
constraint X + Y <= max_total;

% Objective: minimize total operational cost
var int: total_cost = cost_X * X + cost_Y * Y;

solve minimize total_cost;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Minimum monthly operational cost ($) = ", show(total_cost), "\n"
];