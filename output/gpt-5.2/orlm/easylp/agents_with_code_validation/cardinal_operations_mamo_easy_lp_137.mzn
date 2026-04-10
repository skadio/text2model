% Parameters
int: max_total_resources = 100;          % Maximum allowed total resources (X + Y)
int: min_total_resources = 30;           % Minimum required total resources (X + Y)
int: min_effectiveness = 0;              % Minimum required effectiveness score
int: eff_per_x = 2;                      % Effectiveness per unit of X
int: eff_per_y = 3;                      % Effectiveness per unit of Y
int: cost_per_x = 4;                     % Cost per unit of X (dollars)
int: cost_per_y = 5;                     % Cost per unit of Y (dollars)

% Variables
var 0..max_total_resources: x;           % Integer units allocated to initiative X
var 0..max_total_resources: y;           % Integer units allocated to initiative Y
var 0..(cost_per_x*max_total_resources + cost_per_y*max_total_resources): total_cost;
                                         % Total cost in dollars

% Constraints
% --- Resource total bounds (minimum and maximum) ---
constraint min_total_resources <= x + y;
constraint x + y <= max_total_resources;

% --- Effectiveness requirement ---
constraint eff_per_x * x + eff_per_y * y >= min_effectiveness;

% --- Total cost definition ---
constraint total_cost = cost_per_x * x + cost_per_y * y;

% Objective
solve minimize total_cost;