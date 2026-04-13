% Parameters
int: cost_X = 50;              % Cost per unit of product X ($)
int: cost_Y = 10;              % Cost per unit of product Y ($)

int: max_resource = 200;       % Upper limit for 2*X + Y due to resources
int: min_demand = 50;          % Lower limit for 4*X + Y due to demand

% Variables
var 0..max_resource: units_X;  % Whole units of product X produced (non-negative)
var 0..max_resource: units_Y;  % Whole units of product Y produced (non-negative)

% Upper bound: worst case produce max_resource of both products
var 0..(cost_X*max_resource + cost_Y*max_resource): total_cost; % Total cost ($)

% Constraints
% Resource limitation: 2*X + Y cannot exceed available resources
constraint 2 * units_X + units_Y <= max_resource;

% Market demand requirement: 4*X + Y must be at least the minimum demand
constraint 4 * units_X + units_Y >= min_demand;

% Total cost definition
constraint total_cost = cost_X * units_X + cost_Y * units_Y;

% Objective
solve minimize total_cost;