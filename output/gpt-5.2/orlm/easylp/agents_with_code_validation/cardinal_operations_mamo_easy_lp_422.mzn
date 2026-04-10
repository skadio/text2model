% Parameters
int: cost_raw_material = 5;          % $ cost per unit of raw materials
int: cost_labor = 10;                % $ cost per unit of labor
int: min_quality_requirement = 20;   % minimum for 2*raw + 3*labor
int: max_difference = 30;            % |raw - labor| must be <= this
int: fixed_total_units = 100;        % raw + labor must equal this

% Variables
var 0..fixed_total_units: raw_units;   % whole units of raw materials allocated
var 0..fixed_total_units: labor_units; % whole units of labor allocated
var 0..(cost_raw_material * fixed_total_units + cost_labor * fixed_total_units): total_cost; % total $ cost

% Constraints
% Link total_cost to the chosen allocations (cost accounting)
constraint
  total_cost = cost_raw_material * raw_units + cost_labor * labor_units;

% Quality/efficiency requirement: 2*raw + 3*labor must be at least the minimum
constraint
  2 * raw_units + 3 * labor_units >= min_quality_requirement;

% Balance requirement: absolute difference between raw and labor must be within limit
constraint
  abs(raw_units - labor_units) <= max_difference;

% Budget/plan requirement: total allocated units is fixed exactly
constraint
  raw_units + labor_units = fixed_total_units;

% Objective
solve minimize total_cost;