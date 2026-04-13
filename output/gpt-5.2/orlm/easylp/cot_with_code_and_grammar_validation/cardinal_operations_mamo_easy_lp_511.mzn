% Parameters
int: cost_raw = 20;
int: cost_labour = 30;
int: cost_machines = 10;

int: raw_min = 0;
int: raw_max = 2000;

int: labour_min = 0;
int: labour_max = 1500;

int: machines_min = 0;
int: machines_max = 700;

int: min_raw_plus_labour = 1000;
int: max_labour_minus_machines_abs = 500;
int: min_raw_minus_2machines = 400;

% Variables
var raw_min..raw_max: raw;
var labour_min..labour_max: labour;
var machines_min..machines_max: machines;

var 0..(cost_raw*raw_max + cost_labour*labour_max + cost_machines*machines_max): total_cost;

% Constraints
constraint raw + labour >= min_raw_plus_labour;

constraint abs(labour - machines) <= max_labour_minus_machines_abs;

constraint raw - 2 * machines >= min_raw_minus_2machines;

constraint total_cost = cost_raw * raw + cost_labour * labour + cost_machines * machines;

% Objective
solve minimize total_cost;