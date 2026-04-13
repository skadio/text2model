% Parameters (with values embedded)
int: cost_raw = 20;
int: cost_lab = 30;
int: cost_mach = 10;

int: raw_min = 0;
int: raw_max = 2000;
int: lab_min = 0;
int: lab_max = 1500;
int: mach_min = 0;
int: mach_max = 700;

int: min_raw_lab = 1000;
int: max_diff_lab_mach = 500;
int: min_raw_minus_2mach = 400;

% Variables
var raw_min..raw_max: raw;
var lab_min..lab_max: lab;
var mach_min..mach_max: mach;

var 0..(cost_raw*raw_max + cost_lab*lab_max + cost_mach*mach_max): total_cost;

% Constraints
constraint total_cost = cost_raw*raw + cost_lab*lab + cost_mach*mach;

constraint raw + lab >= min_raw_lab;

constraint abs(lab - mach) <= max_diff_lab_mach;

constraint raw - 2*mach >= min_raw_minus_2mach;

% Objective
solve minimize total_cost;