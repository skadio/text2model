% Parameters
% Minimum total number of vehicles required
int: min_total_vehicles = 10;

% Road/scheduling capacity limit for the weighted combination
int: capacity_limit = 25;

% Coefficients in the capacity constraint: 2*X + 3*Y <= 25
int: coeff_x = 2;
int: coeff_y = 3;

% Costs per vehicle
int: cost_x = 5;
int: cost_y = 7;

% Variables
% Number of vehicles of type X and Y (whole vehicles, non-negative)
var 0..capacity_limit: num_x;
var 0..capacity_limit: num_y;

% Total cost (bounded using max possible vehicles under capacity_limit)
var 0..(cost_x * capacity_limit + cost_y * capacity_limit): total_cost;

% Constraints
% Total vehicles demand: use at least the minimum required number of vehicles
constraint num_x + num_y >= min_total_vehicles;

% Road/scheduling capacity constraint: weighted usage must not exceed the limit
constraint coeff_x * num_x + coeff_y * num_y <= capacity_limit;

% Total cost definition: link decision variables to the computed operating cost
constraint total_cost = cost_x * num_x + cost_y * num_y;

% Objective
solve minimize total_cost;