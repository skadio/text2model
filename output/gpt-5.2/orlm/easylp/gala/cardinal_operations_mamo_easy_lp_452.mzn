include "globals.mzn";

% Data (embedded as required)
int: cost_fert = 5;
int: cost_seed = 10;

int: total_units = 500;

int: max_weighted = 1000;     % 2*fert + 3*seed <= 1000
int: min_diff = 200;          % 4*fert - seed >= 200

% Decision variables (whole numbers)
var 0..total_units: fert;     % fertilizer units
var 0..total_units: seed;     % seed units

% Constraints
constraint fert + seed = total_units;
constraint 2 * fert + 3 * seed <= max_weighted;
constraint 4 * fert - seed >= min_diff;

% Objective: minimize total cost
var int: total_cost = cost_fert * fert + cost_seed * seed;

solve minimize total_cost;

output [
  "fert = ", show(fert), "\n",
  "seed = ", show(seed), "\n",
  "min_total_cost = $", show(total_cost), "\n"
];