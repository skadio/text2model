% Parameters
int: max_total_units = 2000;          % Maximum combined units of materials X and Y
int: min_strength = 5000;             % Minimum required strength score

int: strength_X = 3;                  % Strength contribution per unit of X
int: strength_Y = 4;                  % Strength contribution per unit of Y

int: cost_X = 5;                      % Cost per unit of X (dollars)
int: cost_Y = 10;                     % Cost per unit of Y (dollars)

% Variables
var 0..max_total_units: x;            % Units of material X (non-negative integer)
var 0..max_total_units: y;            % Units of material Y (non-negative integer)
var 0..(cost_X*max_total_units + cost_Y*max_total_units): total_cost;  % Total cost (dollars)

% Constraints
% Total units budget constraint: combined units of X and Y cannot exceed the maximum
constraint x + y <= max_total_units;

% Minimum strength requirement: ensure structural integrity meets or exceeds the threshold
constraint strength_X * x + strength_Y * y >= min_strength;

% Total cost definition: link total_cost to decision variables and unit costs
constraint total_cost = cost_X * x + cost_Y * y;

% Objective
solve minimize total_cost;