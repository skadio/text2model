% Diet LP (use float_linear from the linear library to avoid Gecode float limits)
include "linear.mzn";

% Parameters (embedded data)
float: cost_noodles = 5.0;
float: cal_noodles  = 600.0;
float: prot_noodles = 1.5;

float: cost_bar = 2.5;
float: cal_bar  = 250.0;
float: prot_bar = 5.0;

float: min_cal  = 2000.0;
float: min_prot = 16.0;

% Decision variables (nonnegative servings)
var float: x_noodles >= 0.0;
var float: x_bar     >= 0.0;

% Constraints (use float_linear for robust float handling)
constraint float_linear([cal_noodles, cal_bar], [x_noodles, x_bar], ">=", min_cal);
constraint float_linear([prot_noodles, prot_bar], [x_noodles, x_bar], ">=", min_prot);

% Objective: minimize cost
var float: total_cost;
constraint total_cost = cost_noodles * x_noodles + cost_bar * x_bar;

solve minimize total_cost;

output [
  "x_noodles = ", show(x_noodles), "\n",
  "x_bar = ", show(x_bar), "\n",
  "total_cost = ", show(total_cost), "\n"
];