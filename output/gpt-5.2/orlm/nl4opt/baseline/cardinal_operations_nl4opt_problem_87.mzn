% Diet optimization: minimize cost with calorie and protein minimums

% Decision variables (servings per day)
var 0.0..1.0e6: noodles;
var 0.0..1.0e6: bars;

% Data (per serving)
float: cost_noodles = 5.0;
float: cal_noodles  = 600.0;
float: prot_noodles = 1.5;

float: cost_bar = 2.5;
float: cal_bar  = 250.0;
float: prot_bar = 5.0;

% Daily requirements
float: min_calories = 2000.0;
float: min_protein  = 16.0;

% Constraints
constraint cal_noodles * noodles + cal_bar * bars >= min_calories;
constraint prot_noodles * noodles + prot_bar * bars >= min_protein;

% Objective: minimize total cost
var float: total_cost = cost_noodles * noodles + cost_bar * bars;
solve minimize total_cost;

output [
  "noodles_servings = ", show(noodles), "\n",
  "bars_servings    = ", show(bars), "\n",
  "total_cost       = $", show(total_cost), "\n",
  "total_calories   = ", show(cal_noodles * noodles + cal_bar * bars), "\n",
  "total_protein    = ", show(prot_noodles * noodles + prot_bar * bars), "\n"
];