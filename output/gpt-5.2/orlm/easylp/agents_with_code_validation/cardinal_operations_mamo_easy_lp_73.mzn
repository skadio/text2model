% Parameters
int: max_weighted_acres = 50;          % Upper bound for 2*X + 3*Y
int: min_x_minus_y = 10;              % Constraint: X >= Y + 10
int: cost_per_acre_x = 100;           % Cost per acre of crop X
int: cost_per_acre_y = 200;           % Cost per acre of crop Y

% Variables
var 0..max_weighted_acres: acres_x;   % Whole acres planted with crop X
var 0..max_weighted_acres: acres_y;   % Whole acres planted with crop Y
var 0..(cost_per_acre_x*max_weighted_acres + cost_per_acre_y*max_weighted_acres): total_cost; % Total cost ($)

% Constraints
% Land/irrigation capacity: weighted acreage limit (2*X + 3*Y <= 50)
constraint 2 * acres_x + 3 * acres_y <= max_weighted_acres;

% Agronomic requirement: crop X must be at least 10 acres more than crop Y
constraint acres_x - acres_y >= min_x_minus_y;

% Cost accounting: total_cost equals sum of per-acre costs
constraint total_cost = cost_per_acre_x * acres_x + cost_per_acre_y * acres_y;

% Objective
solve minimize total_cost;