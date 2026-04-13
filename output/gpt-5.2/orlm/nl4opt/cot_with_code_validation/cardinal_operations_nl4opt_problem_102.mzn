% Diet problem: minimize cost while meeting calorie and protein minimums

% Parameters (embedded data)
float: cost_rice = 3.0;
float: cost_kebab = 2.0;

float: cal_rice = 300.0;
float: cal_kebab = 200.0;

float: prot_rice = 4.5;
float: prot_kebab = 4.0;

float: min_cal = 2200.0;
float: min_prot = 30.0;

% Variables (integer servings to avoid LP-to-FD issues/timeouts)
var 0..100: rice_servings;
var 0..100: kebab_servings;

% Constraints
constraint cal_rice * rice_servings + cal_kebab * kebab_servings >= min_cal;
constraint prot_rice * rice_servings + prot_kebab * kebab_servings >= min_prot;

% Objective
var float: total_cost = cost_rice * rice_servings + cost_kebab * kebab_servings;
solve minimize total_cost;

output [
  "rice_servings=", show(rice_servings), "\n",
  "kebab_servings=", show(kebab_servings), "\n",
  "total_cost=", show(total_cost), "\n"
];