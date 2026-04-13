% Parameters
int: total_budget = 1000;                  % Maximum total resource units across X, Y, Z
int: min_xy_combined = 200;                % Minimum for X + Y
int: min_y_2z_combined = 300;              % Minimum for Y + 2*Z

int: cost_x = 10;                          % Cost per unit for channel X
int: cost_y = 15;                          % Cost per unit for channel Y
int: cost_z = 20;                          % Cost per unit for channel Z

% Variables
var 0..total_budget: x;                    % Resource units allocated to channel X
var 0..total_budget: y;                    % Resource units allocated to channel Y
var 0..total_budget: z;                    % Resource units allocated to channel Z

var 0..(cost_x*total_budget + cost_y*total_budget + cost_z*total_budget): total_cost;
                                            % Total cost in dollars (integer)

% Constraints
% Budget constraint: total allocated resources cannot exceed the overall budget
constraint x + y + z <= total_budget;

% Effectiveness constraint for channels X and Y: X must be at least twice Y
constraint x >= 2 * y;

% Minimum combined allocation requirement for channels X and Y
constraint x + y >= min_xy_combined;

% Minimum combined allocation requirement for channel Y and twice channel Z
constraint y + 2 * z >= min_y_2z_combined;

% Total cost definition from per-unit costs and allocations
constraint total_cost = cost_x * x + cost_y * y + cost_z * z;

% Objective
solve minimize total_cost;