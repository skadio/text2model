include "globals.mzn";

% Data (embedded from problem description)
int: cost_raw = 4;
int: cost_labor = 3;
int: cost_trans = 2;

int: min_raw_plus_labor = 50;
int: max_labor_minus_trans_abs = 10;
int: raw_minus_labor_eq = 20;
int: max_raw_plus_trans = 100;

% Decision variables (whole-number allocations)
var 0..1000: raw;
var 0..1000: labor;
var 0..1000: trans;

% Constraints
constraint raw + labor >= min_raw_plus_labor;
constraint abs(labor - trans) <= max_labor_minus_trans_abs;
constraint raw - labor = raw_minus_labor_eq;
constraint raw + trans <= max_raw_plus_trans;

% Objective: minimize total cost
var int: total_cost = cost_raw * raw + cost_labor * labor + cost_trans * trans;

solve minimize total_cost;

output [
  "raw = ", show(raw), "\n",
  "labor = ", show(labor), "\n",
  "trans = ", show(trans), "\n",
  "total_cost = ", show(total_cost), "\n"
];