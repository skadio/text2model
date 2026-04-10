% Parameters
int: max_total_items = 200;              % Storage capacity: x + y <= 200
int: min_weighted_demand = 150;          % Demand requirement: 3*x + 2*y >= 150
int: demand_coeff_x = 3;                % Coefficient for product X in demand
int: demand_coeff_y = 2;                % Coefficient for product Y in demand
int: cost_x = 5;                        % Unit cost of product X ($)
int: cost_y = 10;                       % Unit cost of product Y ($)

% Variables
var 0..max_total_items: units_x;         % Whole units of product X to stock
var 0..max_total_items: units_y;         % Whole units of product Y to stock
var 0..(max_total_items * max(cost_x, cost_y)): total_cost; % Total cost in dollars

% Constraints
% Storage capacity: total items stocked cannot exceed the maximum capacity
constraint units_x + units_y <= max_total_items;

% Demand satisfaction: weighted combination of units must meet minimum demand
constraint demand_coeff_x * units_x + demand_coeff_y * units_y >= min_weighted_demand;

% Total cost definition: compute total cost from chosen quantities
constraint total_cost = cost_x * units_x + cost_y * units_y;

% Objective
solve minimize total_cost;