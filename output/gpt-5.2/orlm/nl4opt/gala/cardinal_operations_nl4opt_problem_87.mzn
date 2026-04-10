% Diet optimization: minimize cost of noodles and protein bars
% Data is embedded as requested.

include "globals.mzn";

% Decision variables (number of servings per day; nonnegative integers)
var 0..1000: noodles;
var 0..1000: bars;

% Parameters
float: cost_noodles = 5.0;
float: cost_bar     = 2.5;

int: cal_noodles = 600;
int: cal_bar     = 250;

float: prot_noodles = 1.5;
float: prot_bar     = 5.0;

int: min_cal = 2000;
float: min_prot = 16.0;

% Constraints
constraint cal_noodles * noodles + cal_bar * bars >= min_cal;
constraint prot_noodles * int2float(noodles) + prot_bar * int2float(bars) >= min_prot;

% Objective: minimize total cost
var float: total_cost = cost_noodles * int2float(noodles) + cost_bar * int2float(bars);

solve minimize total_cost;

output [
  "noodles = ", show(noodles), "\n",
  "bars    = ", show(bars), "\n",
  "total_cost = $", show(total_cost), "\n",
  "total_calories = ", show(cal_noodles * noodles + cal_bar * bars), "\n",
  "total_protein  = ", show(prot_noodles * int2float(noodles) + prot_bar * int2float(bars)), " g\n"
];