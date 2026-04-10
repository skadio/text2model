% Parameters
% Cost coefficients (units per resource)
float: cost_raw_materials = 2.0;
float: cost_labour_hours = 3.0;
float: cost_production_costs = 1.5;
float: cost_transportation_costs = 4.0;

% Constraint constants
int: min_raw_plus_labour = 500;         % raw materials + labour hours >= 500
int: prod_over_half_raw_limit = 1000;   % production_costs <= raw_materials/2 + 1000
int: min_transport_over_labour = 200;   % transportation_costs >= labour_hours + 200

% Bounds (explicit large upper bounds since none were provided)
int: ub_raw_materials = 100000;
int: ub_labour_hours = 100000;
int: ub_production_costs = 100000;
int: ub_transportation_costs = 100000;

% Variables
var 0..ub_raw_materials: raw_materials;                 % allocated raw materials (integer units)
var 0..ub_labour_hours: labour_hours;                   % allocated labour hours (integer units)
var 0..ub_production_costs: production_costs;           % allocated production costs (integer units)
var 0..ub_transportation_costs: transportation_costs;   % allocated transportation costs (integer units)

var float: total_cost; % total cost to minimize (float due to 1.5 coefficient)

% Constraints

% --- Productivity requirement: raw materials + labour hours must meet minimum ---
constraint raw_materials + labour_hours >= min_raw_plus_labour;

% --- Operational efficiency: production costs limited relative to raw materials ---
% production_costs <= raw_materials/2 + prod_over_half_raw_limit
% Use integer-safe form to avoid fractional division:
constraint 2 * production_costs <= raw_materials + 2 * prod_over_half_raw_limit;

% --- Logistics requirement: transportation must exceed labour by at least a margin ---
constraint transportation_costs >= labour_hours + min_transport_over_labour;

% --- Balance policy: raw + production - labour must be zero ---
constraint raw_materials + production_costs - labour_hours = 0;

% --- Total cost definition ---
constraint total_cost =
    cost_raw_materials * raw_materials +
    cost_labour_hours * labour_hours +
    cost_production_costs * production_costs +
    cost_transportation_costs * transportation_costs;

% Objective
solve minimize total_cost;