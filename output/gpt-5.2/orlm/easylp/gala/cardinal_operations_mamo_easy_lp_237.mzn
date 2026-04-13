% Farmland allocation: wheat, corn, soybeans (integer acres)
% Minimize total cultivation cost subject to linear constraints.

include "globals.mzn";

% Decision variables (acres, whole numbers)
var 0..100: wheat;
var 0..100: corn;
var 0..100: soy;

% Costs per acre
int: cost_wheat = 5;
int: cost_corn  = 4;
int: cost_soy   = 6;

% Constraints
constraint 2*wheat + corn <= 50;
constraint wheat + 3*soy <= 60;
constraint corn + soy >= 30;

% Objective: minimize total cost
var int: total_cost = cost_wheat*wheat + cost_corn*corn + cost_soy*soy;

solve minimize total_cost;

output [
  "wheat = ", show(wheat), "\n",
  "corn  = ", show(corn),  "\n",
  "soy   = ", show(soy),   "\n",
  "min_total_cost = ", show(total_cost), "\n"
];