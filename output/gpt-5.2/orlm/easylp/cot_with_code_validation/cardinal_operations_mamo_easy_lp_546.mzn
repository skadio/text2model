% Parameters
int: cost_raw = 4;
int: cost_labor = 3;
int: cost_trans = 2;

int: min_raw_plus_labor = 50;
int: max_labor_minus_trans = 10;
int: raw_minus_labor_eq = 20;
int: max_raw_plus_trans = 100;

% Variables
var 0..1000: raw;
var 0..1000: labor;
var 0..1000: trans;

var 0..1000000: total_cost;

% Constraints
constraint raw + labor >= min_raw_plus_labor;
constraint labor - trans <= max_labor_minus_trans;
constraint raw - labor = raw_minus_labor_eq;
constraint raw + trans <= max_raw_plus_trans;

constraint total_cost = cost_raw * raw + cost_labor * labor + cost_trans * trans;

% Objective
solve minimize total_cost;