% Parameters
int: max_weighted_acres = 50;        % Upper bound for 2*X + 3*Y
int: min_diff_xy = 10;               % Minimum required difference: X >= Y + 10
int: cost_per_acre_x = 100;          % Cost per acre of crop X
int: cost_per_acre_y = 200;          % Cost per acre of crop Y

% Variables
var 0..max_weighted_acres: acres_x;  % Acres planted with crop X (integer, non-negative)
var 0..max_weighted_acres: acres_y;  % Acres planted with crop Y (integer, non-negative)
var 0..(cost_per_acre_x*max_weighted_acres + cost_per_acre_y*max_weighted_acres): total_cost;
                                     % Total cost in dollars (integer, bounded)

% Constraints
% Land/irrigation capacity: weighted acreage limit
constraint 2 * acres_x + 3 * acres_y <= max_weighted_acres;

% Planting policy: crop X must exceed crop Y by at least the required difference
constraint acres_x >= acres_y + min_diff_xy;

% Cost accounting: total cost equals sum of per-acre costs
constraint total_cost = cost_per_acre_x * acres_x + cost_per_acre_y * acres_y;

% Objective
solve minimize total_cost;