% Parameters
int: max_total_vehicles = 1000;          % Maximum total vehicles supported
int: min_x = 200;                        % Minimum allocation for vehicle X
int: min_y = 300;                        % Minimum allocation for vehicle Y
int: max_x = 500;                        % Maximum allocation for vehicle X
int: max_y = 700;                        % Maximum allocation for vehicle Y
int: cost_x = 50;                        % Support points per unit of X
int: cost_y = 70;                        % Support points per unit of Y

% Variables
var min_x..max_x: x_units;               % Number of vehicle X units (integer)
var min_y..max_y: y_units;               % Number of vehicle Y units (integer)
var 0..(cost_x*max_x + cost_y*max_y): total_support_points; % Total support points (integer)

% Constraints
% Total vehicles maintenance capacity constraint
constraint
  x_units + y_units <= max_total_vehicles;

% Define total support points from chosen allocations
constraint
  total_support_points = cost_x * x_units + cost_y * y_units;

% Objective
solve minimize total_support_points;