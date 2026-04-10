% Parameters
int: cost_raw = 20;
int: cost_lab = 30;
int: cost_mach = 10;

int: raw_lb = 0;
int: raw_ub = 2000;
int: lab_lb = 0;
int: lab_ub = 1500;
int: mach_lb = 0;
int: mach_ub = 700;

int: min_raw_lab = 1000;
int: max_diff_lab_mach = 500;
int: min_raw_minus_2mach = 400;

% Variables
var raw_lb..raw_ub: raw;
var lab_lb..lab_ub: lab;
var mach_lb..mach_ub: mach;

var 0..(cost_raw*raw_ub + cost_lab*lab_ub + cost_mach*mach_ub): total_cost;

% Constraints
constraint raw + lab >= min_raw_lab;

constraint abs(lab - mach) <= max_diff_lab_mach;

constraint raw - 2 * mach >= min_raw_minus_2mach;

constraint total_cost = cost_raw * raw + cost_lab * lab + cost_mach * mach;

% Objective
solve minimize total_cost;