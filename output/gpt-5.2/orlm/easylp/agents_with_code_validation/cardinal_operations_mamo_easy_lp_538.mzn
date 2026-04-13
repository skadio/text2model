% Parameters
int: labor_cost = 5;          % cost per labor hour
int: material_cost = 3;       % cost per unit of material
int: equipment_cost = 2;      % cost per unit of equipment

int: max_budget_expr = 1000;  % upper bound for 4*labor + material
int: min_strength_expr = 500; % lower bound for 2*labor + 3*equipment
int: mat_equip_diff = 100;    % material - equipment must equal this

% Variables
var 0..250: labor_hours;        % non-negative integer labor hours (since 4*labor <= 1000)
var 0..1000: material_units;    % non-negative integer material units
var 0..1000: equipment_units;   % non-negative integer equipment units

var 0..(labor_cost*250 + material_cost*1000 + equipment_cost*1000): total_cost; % objective value

% Constraints
% Budget limitation: 4*labor_hours + material_units <= 1000
constraint 4 * labor_hours + material_units <= max_budget_expr;

% Minimum strength requirement: 2*labor_hours + 3*equipment_units >= 500
constraint 2 * labor_hours + 3 * equipment_units >= min_strength_expr;

% Exact difference requirement: material_units - equipment_units = 100
constraint material_units - equipment_units = mat_equip_diff;

% Define total_cost based on unit costs and allocations
constraint total_cost =
    labor_cost * labor_hours
  + material_cost * material_units
  + equipment_cost * equipment_units;

% Objective
solve minimize total_cost;