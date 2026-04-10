% Parameters
int: cost_raw = 5;
int: cost_labor = 4;
int: cost_trans = 6;

int: min_excess_raw_over_2labor = 500;
int: max_labor_plus_trans = 1000;
int: raw_minus_trans = 200;

% Variables
var 0..1000000: raw;
var 0..1000000: labor;
var 0..1000000: trans;

var 0..1000000000: total_cost;

% Constraints
constraint raw >= 2 * labor + min_excess_raw_over_2labor;
constraint labor + trans <= max_labor_plus_trans;
constraint raw = trans + raw_minus_trans;

constraint total_cost = cost_raw * raw + cost_labor * labor + cost_trans * trans;

% Objective
solve minimize total_cost;