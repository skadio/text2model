% Parameters
% Unit costs for each resource (in dollars per unit)
int: cost_raw_materials = 10;   % $ per unit of raw materials
int: cost_labor_hours   = 5;    % $ per unit of labor hours
int: cost_machine_hours = 15;   % $ per unit of machine hours
int: cost_energy_usage  = 20;   % $ per unit of energy usage

% Minimum combined total units required
int: min_total_units = 500;

% Variables
% Decision variables: integer allocations for each resource (bounded for search)
var 0..min_total_units: raw_materials;
var 0..min_total_units: labor_hours;
var 0..min_total_units: machine_hours;
var 0..min_total_units: energy_usage;

% Total cost variable (upper bound based on worst-case unit cost sum)
var 0..(cost_raw_materials + cost_labor_hours + cost_machine_hours + cost_energy_usage) * min_total_units: total_cost;

% Constraints
% Cost accounting: total_cost equals the weighted sum of all resource units
constraint total_cost =
    cost_raw_materials * raw_materials +
    cost_labor_hours   * labor_hours +
    cost_machine_hours * machine_hours +
    cost_energy_usage  * energy_usage;

% Quality constraint: raw materials used at least twice the labor hours
constraint raw_materials >= 2 * labor_hours;

% Capacity constraint: labor hours cannot exceed machine hours
constraint labor_hours <= machine_hours;

% Operational efficiency: machine hours must equal energy usage
constraint machine_hours = energy_usage;

% Minimum production requirement: total units across all resources at least the required minimum
constraint raw_materials + labor_hours + machine_hours + energy_usage >= min_total_units;

% Objective
solve minimize total_cost;