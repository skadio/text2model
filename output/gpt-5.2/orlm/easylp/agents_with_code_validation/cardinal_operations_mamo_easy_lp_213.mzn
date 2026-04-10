% Parameters
int: max_total_units = 100;                 % Total available resource units across all programs

int: min_units_X = 10;                      % Minimum required units for Program X
int: min_units_Y = 20;                      % Minimum required units for Program Y
int: min_units_Z = 15;                      % Minimum required units for Program Z

int: cost_per_unit_X = 30;                  % Cost per unit for Program X (dollars)
int: cost_per_unit_Y = 20;                  % Cost per unit for Program Y (dollars)
int: cost_per_unit_Z = 50;                  % Cost per unit for Program Z (dollars)

% Variables
var min_units_X..max_total_units: units_X;  % Integer units allocated to Program X
var min_units_Y..max_total_units: units_Y;  % Integer units allocated to Program Y
var min_units_Z..max_total_units: units_Z;  % Integer units allocated to Program Z

var 0..(max_total_units * max([cost_per_unit_X, cost_per_unit_Y, cost_per_unit_Z])): total_cost;
                                            % Total cost (bounded above by worst-case per-unit cost)

% Constraints
% Enforce total resource availability across all programs
constraint
    units_X + units_Y + units_Z <= max_total_units;

% Define total cost from per-program allocations and unit costs
constraint
    total_cost = cost_per_unit_X * units_X
               + cost_per_unit_Y * units_Y
               + cost_per_unit_Z * units_Z;

% Objective
solve minimize total_cost;