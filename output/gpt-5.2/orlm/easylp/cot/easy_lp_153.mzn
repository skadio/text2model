% Parameters (with values embedded)
int: max_total_weight = 40000;
int: min_total_vehicles = 3000;

int: cost_X = 10;
int: cost_Y = 20;

% Vehicle capacities in pounds (must be specified to model the weight constraint)
% The problem statement does not provide capacities for X and Y, so the model
% cannot determine feasibility or an optimal cost without them.
int: cap_X = 0;
int: cap_Y = 0;

% Variables
var 0..min_total_vehicles: X;
var 0..min_total_vehicles: Y;
var 0..int_max: total_cost;

% Constraints
constraint X + Y >= min_total_vehicles;
constraint cap_X * X + cap_Y * Y <= max_total_weight;

constraint total_cost = cost_X * X + cost_Y * Y;

% Objective
solve minimize total_cost;