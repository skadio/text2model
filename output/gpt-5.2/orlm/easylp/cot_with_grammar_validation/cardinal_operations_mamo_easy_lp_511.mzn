% Parameters
int: cost_raw = 20;
int: cost_labour = 30;
int: cost_machines = 10;

int: min_raw_labour = 1000;
int: max_diff_labour_machines = 500;
int: min_raw_minus_2machines = 400;

int: raw_lb = 0;
int: raw_ub = 2000;
int: labour_lb = 0;
int: labour_ub = 1500;
int: machines_lb = 0;
int: machines_ub = 700;

% Variables
var raw_lb..raw_ub: raw;
var labour_lb..labour_ub: labour;
var machines_lb..machines_ub: machines;

var 0..(cost_raw*raw_ub + cost_labour*labour_ub + cost_machines*machines_ub): total_cost;

% Constraints
constraint raw + labour >= min_raw_labour;

constraint abs(labour - machines) <= max_diff_labour_machines;

constraint raw - 2 * machines >= min_raw_minus_2machines;

constraint total_cost = cost_raw * raw + cost_labour * labour + cost_machines * machines;

% Objective
solve minimize total_cost;