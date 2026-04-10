% Parameters
int: cost_x = 50;                    % production cost per unit of product X ($)
int: cost_y = 75;                    % production cost per unit of product Y ($)

int: max_total_units = 1200;         % capacity limit: x + y <= 1200
int: min_gap_xy = 300;               % minimum gap: x - y >= 300 (more X than Y)
int: storage_limit = 2000;           % storage limit: 2*x + y <= 2000

% Variables
var 0..max_total_units: x_units;     % units of product X (non-negative integer)
var 0..max_total_units: y_units;     % units of product Y (non-negative integer)

% Upper bound is a safe overestimate: maximum possible cost if both hit max_total_units
var 0..(cost_x*max_total_units + cost_y*max_total_units): total_cost; % total production cost ($)

% Constraints
% Capacity constraint: combined production cannot exceed total capacity
constraint
  x_units + y_units <= max_total_units;

% Minimum gap constraint: produce at least min_gap_xy more X than Y
constraint
  x_units - y_units >= min_gap_xy;

% Storage limitation: weighted sum of units cannot exceed storage_limit
constraint
  2 * x_units + y_units <= storage_limit;

% Total cost definition: compute total production cost from unit costs
constraint
  total_cost = cost_x * x_units + cost_y * y_units;

% Objective
solve minimize total_cost;