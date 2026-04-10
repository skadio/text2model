% Parameters
int: c_raw = 5;
int: c_labor = 4;
int: c_trans = 6;

int: min_gap_raw_vs_2labor = 500;
int: max_labor_plus_trans = 1000;
int: raw_minus_trans = 200;

% Variables
var 0..2000: raw;
var 0..2000: labor;
var 0..2000: trans;

var 0..10000000: total_cost;

% Constraints
constraint raw >= 2 * labor + min_gap_raw_vs_2labor;
constraint labor + trans <= max_labor_plus_trans;
constraint raw = trans + raw_minus_trans;

constraint total_cost = c_raw * raw + c_labor * labor + c_trans * trans;

% Objective
solve minimize total_cost;