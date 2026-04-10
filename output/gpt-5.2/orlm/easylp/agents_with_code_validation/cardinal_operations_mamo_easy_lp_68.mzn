% Parameters
int: max_acres = 50;                 % Maximum total acres available
int: min_total_acres = 40;           % Minimum total acres to plant

int: cost_x = 5;                     % Cost per acre for crop X (USD)
int: cost_y = 10;                    % Cost per acre for crop Y (USD)

int: extra_x_over_2y_limit = 10;     % X cannot exceed 2*Y by more than 10 acres


% Variables
var 0..max_acres: acres_x;           % Acres planted with crop X (integer acres)
var 0..max_acres: acres_y;           % Acres planted with crop Y (integer acres)

% Upper bound: worst-case cost if both were at max_acres (safe, though loose)
var 0..(cost_x*max_acres + cost_y*max_acres): total_cost;  % Total planting cost (USD, integer)


% Constraints
% Land availability (total acres planted must be within allowed bounds)
constraint acres_x + acres_y <= max_acres;
constraint acres_x + acres_y >= min_total_acres;

% Demand/ratio requirement (must plant at least twice as much X as Y)
constraint acres_x >= 2 * acres_y;

% Upper deviation limit (X cannot exceed 2Y by more than the allowed extra)
constraint acres_x <= 2 * acres_y + extra_x_over_2y_limit;

% Total cost definition (link decision variables to total_cost)
constraint total_cost = cost_x * acres_x + cost_y * acres_y;


% Objective
solve minimize total_cost;