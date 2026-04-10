% Parameters
int: max_total_items = 200;              % Storage capacity: x + y <= 200
int: min_weighted_sales = 150;           % Demand: 3*x + 2*y >= 150
int: weight_x = 3;                       % Contribution of product X to demand
int: weight_y = 2;                       % Contribution of product Y to demand
int: cost_x = 5;                         % Cost per unit of X ($)
int: cost_y = 10;                        % Cost per unit of Y ($)

% Variables
var 0..max_total_items: units_x;         % Whole units of product X to stock
var 0..max_total_items: units_y;         % Whole units of product Y to stock
var 0..(cost_x*max_total_items + cost_y*max_total_items): total_cost; % Total cost ($)

% Constraints
% Storage capacity constraint: total items cannot exceed capacity
constraint units_x + units_y <= max_total_items;

% Demand satisfaction constraint: weighted units sold must meet minimum demand
constraint weight_x * units_x + weight_y * units_y >= min_weighted_sales;

% Total cost definition: link total_cost to chosen quantities and unit costs
constraint total_cost = cost_x * units_x + cost_y * units_y;

% Objective
solve minimize total_cost;