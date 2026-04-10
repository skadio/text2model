% Parameters
int: max_total_weight = 40000;
int: min_total_vehicles = 3000;

int: cost_X = 10;
int: cost_Y = 20;

% NOTE: Vehicle capacities (weights per vehicle) are not specified in the description.
% They are required to model the weight constraint meaningfully.
% Set placeholder capacities to 1 to keep the model well-defined.
int: cap_X = 1;
int: cap_Y = 1;

% Variables
var 0..min_total_vehicles: X;
var 0..min_total_vehicles: Y;
var 0..(cost_X*min_total_vehicles + cost_Y*min_total_vehicles): total_cost;

% Constraints
constraint X + Y >= min_total_vehicles;

constraint cap_X * X + cap_Y * Y <= max_total_weight;

constraint total_cost = cost_X * X + cost_Y * Y;

% Objective
solve minimize total_cost;