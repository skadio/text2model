% Parameters
int: cost_raw_materials = 10;     % cost per unit of raw materials
int: cost_labor_hours   = 5;      % cost per unit of labor hours
int: cost_machine_hours = 15;     % cost per unit of machine hours
int: cost_energy_usage  = 20;     % cost per unit of energy usage

int: min_total_units = 500;       % minimum combined total units required


% Variables
var 0..min_total_units: raw_materials;   % units of raw materials used (non-negative integer)
var 0..min_total_units: labor_hours;     % labor hours used (non-negative integer)
var 0..min_total_units: machine_hours;   % machine hours operated (non-negative integer)
var 0..min_total_units: energy_usage;    % energy usage (non-negative integer)

% Upper bound is the worst case if all resources were at min_total_units.
var 0..(cost_raw_materials*min_total_units
      + cost_labor_hours*min_total_units
      + cost_machine_hours*min_total_units
      + cost_energy_usage*min_total_units): total_cost; % total production cost (bounded)


% Constraints
% Resource relationship constraints (quality/efficiency rules)
constraint raw_materials >= 2 * labor_hours;      % raw materials at least twice labor hours
constraint labor_hours <= machine_hours;          % labor hours cannot exceed machine hours
constraint machine_hours = energy_usage;          % machine hours must equal energy usage

% Minimum production requirement (total units across all resources)
constraint raw_materials + labor_hours + machine_hours + energy_usage >= min_total_units;

% Total cost definition (link total_cost variable to resource usage and unit costs)
constraint total_cost =
  cost_raw_materials * raw_materials +
  cost_labor_hours   * labor_hours +
  cost_machine_hours * machine_hours +
  cost_energy_usage  * energy_usage;


% Objective
solve minimize total_cost;