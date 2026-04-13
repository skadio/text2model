% Parameters
int: cost_raw = 10;
int: cost_labor = 5;
int: cost_machine = 15;
int: cost_energy = 20;
int: min_total_units = 500;

% Variables
var 0..min_total_units: raw;
var 0..min_total_units: labor;
var 0..min_total_units: machine;
var 0..min_total_units: energy;

var 0..(cost_raw + cost_labor + cost_machine + cost_energy) * min_total_units: total_cost;

% Constraints
constraint raw >= 2 * labor;
constraint labor <= machine;
constraint machine = energy;
constraint raw + labor + machine + energy >= min_total_units;

constraint total_cost = cost_raw * raw
                      + cost_labor * labor
                      + cost_machine * machine
                      + cost_energy * energy;

% Objective
solve minimize total_cost;