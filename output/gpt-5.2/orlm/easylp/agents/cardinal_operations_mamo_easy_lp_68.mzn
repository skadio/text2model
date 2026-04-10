% Parameters
int: max_acres = 50;                 % Maximum total acres available
int: min_total_acres = 40;           % Minimum total acres that must be planted

int: cost_x = 5;                     % Cost per acre for crop X (dollars)
int: cost_y = 10;                    % Cost per acre for crop Y (dollars)

int: extra_x_over_2y_max = 10;       % Maximum allowed excess of X over (2*Y)

% Variables
var 0..max_acres: acres_x;           % Acres planted with crop X (integer acres)
var 0..max_acres: acres_y;           % Acres planted with crop Y (integer acres)

var 0..(cost_x*max_acres + cost_y*max_acres): total_cost;  % Total planting cost (dollars)

% Constraints
% Total planted acreage must be within available land
constraint acres_x + acres_y <= max_acres;

% Total planted acreage must meet minimum required planted area
constraint acres_x + acres_y >= min_total_acres;

% Market demand: plant at least twice as much X as Y
constraint acres_x >= 2 * acres_y;

% Limit on how much X can exceed twice Y (X - 2Y <= extra_x_over_2y_max)
constraint acres_x - 2 * acres_y <= extra_x_over_2y_max;

% Define total cost from per-acre costs
constraint total_cost = cost_x * acres_x + cost_y * acres_y;

% Objective
solve minimize total_cost;