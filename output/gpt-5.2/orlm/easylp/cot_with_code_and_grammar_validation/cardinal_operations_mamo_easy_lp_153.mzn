% Parameters
int: max_total_weight = 40000;
int: min_total_vehicles = 3000;

int: cost_X = 10;
int: cost_Y = 20;

% NOTE: The problem statement says X and Y have different capacities but does not
% provide their weight capacities. Without these, the weight constraint cannot be
% expressed meaningfully. We include placeholder capacities; replace with correct data.
int: cap_X = 1;  % pounds per vehicle X (placeholder)
int: cap_Y = 1;  % pounds per vehicle Y (placeholder)

% Variables
var 0..min_total_vehicles: x; % number of vehicles of type X
var 0..min_total_vehicles: y; % number of vehicles of type Y
var 0..(cost_X*min_total_vehicles + cost_Y*min_total_vehicles): total_cost;

% Constraints
constraint x + y >= min_total_vehicles;
constraint cap_X * x + cap_Y * y <= max_total_weight;

constraint total_cost = cost_X * x + cost_Y * y;

% Objective
solve minimize total_cost;