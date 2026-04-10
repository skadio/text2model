include "globals.mzn";

% Data (embedded from the problem statement)
int: max_wheat_corn = 50;
int: max_rice_soy   = 30;
int: min_wheat_rice = 20;
int: min_corn_soy   = 15;

int: cost_wheat = 4;
int: cost_corn  = 3;
int: cost_rice  = 2;
int: cost_soy   = 1;

% Decision variables: whole-number units planted of each crop
var 0..max_wheat_corn: wheat;
var 0..max_wheat_corn: corn;
var 0..max_rice_soy:   rice;
var 0..max_rice_soy:   soy;

% Constraints
constraint wheat + corn <= max_wheat_corn;
constraint rice + soy   <= max_rice_soy;

constraint wheat + rice >= min_wheat_rice;
constraint corn + soy   >= min_corn_soy;

% Objective: minimize total planting cost
var int: total_cost = cost_wheat*wheat + cost_corn*corn + cost_rice*rice + cost_soy*soy;

solve minimize total_cost;

output [
  "Minimum cost = $", show(total_cost), "\n",
  "wheat=", show(wheat), " corn=", show(corn), " rice=", show(rice), " soy=", show(soy), "\n"
];