% Parameters
int: max_total_units = 2000;          % Upper bound on X + Y
int: min_strength = 5000;             % Lower bound on 3*X + 4*Y
int: strength_x = 3;                  % Strength contribution per unit of X
int: strength_y = 4;                  % Strength contribution per unit of Y
int: cost_x = 5;                      % Cost per unit of X (dollars)
int: cost_y = 10;                     % Cost per unit of Y (dollars)

% Variables
var 0..max_total_units: x;            % Units of material X (integer, nonnegative)
var 0..max_total_units: y;            % Units of material Y (integer, nonnegative)
var 0..(cost_x*max_total_units + cost_y*max_total_units): total_cost; % Total cost (dollars)

% Constraints
% Budget/availability constraint: total units of materials cannot exceed the limit
constraint x + y <= max_total_units;

% Structural integrity constraint: combined strength must meet the minimum required
constraint strength_x * x + strength_y * y >= min_strength;

% Total cost definition: link total_cost to the chosen quantities and unit costs
constraint total_cost = cost_x * x + cost_y * y;

% Objective
solve minimize total_cost;