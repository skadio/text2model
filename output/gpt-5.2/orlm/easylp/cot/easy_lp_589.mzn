% Parameters (with values embedded)
int: cost_raw = 10;
int: cost_labor = 5;
int: cost_machine = 15;
int: cost_energy = 20;

int: min_total_units = 500;

% Variables
var 0..min_total_units: raw_materials;
var 0..min_total_units: labor_hours;
var 0..min_total_units: machine_hours;
var 0..min_total_units: energy_usage;

var 0..(cost_raw + cost_labor + cost_machine + cost_energy) * min_total_units: total_cost;

% Constraints
constraint raw_materials >= 2 * labor_hours;
constraint labor_hours <= machine_hours;
constraint machine_hours = energy_usage;
constraint raw_materials + labor_hours + machine_hours + energy_usage >= min_total_units;

constraint total_cost =
  cost_raw * raw_materials +
  cost_labor * labor_hours +
  cost_machine * machine_hours +
  cost_energy * energy_usage;

% Objective
solve minimize total_cost;