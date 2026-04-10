% Parameters
int: min_vehicles = 10;              % Minimum total number of vehicles required
int: cap_limit = 25;                 % Capacity/scheduling upper limit
int: cap_x_coeff = 2;                % Coefficient for vehicle X in capacity constraint
int: cap_y_coeff = 3;                % Coefficient for vehicle Y in capacity constraint
int: cost_x = 5;                     % Cost per vehicle X
int: cost_y = 7;                     % Cost per vehicle Y

% Variables
var 0..min_vehicles: x;              % Number of type X vehicles (non-negative integer)
var 0..min_vehicles: y;              % Number of type Y vehicles (non-negative integer)
var 0..(cost_x*min_vehicles + cost_y*min_vehicles): total_cost;  % Total operating cost

% Constraints
% Meet minimum demand: total vehicles used must be at least min_vehicles
constraint x + y >= min_vehicles;

% Road capacity / scheduling constraint
constraint cap_x_coeff * x + cap_y_coeff * y <= cap_limit;

% Define total operating cost from decision variables
constraint total_cost = cost_x * x + cost_y * y;

% Objective
solve minimize total_cost;