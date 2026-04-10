% Parameters
int: max_total_vehicles = 1000;          % Total vehicles supported (maintenance constraint)
int: min_x = 200;                        % Minimum allocation for vehicle type X
int: min_y = 300;                        % Minimum allocation for vehicle type Y
int: max_x = 500;                        % Maximum allocation for vehicle type X
int: max_y = 700;                        % Maximum allocation for vehicle type Y
int: cost_x = 50;                        % Support points per unit of X
int: cost_y = 70;                        % Support points per unit of Y

% Variables
var min_x..max_x: x;                     % Number of vehicle type X (integer)
var min_y..max_y: y;                     % Number of vehicle type Y (integer)
var 0..(cost_x*max_x + cost_y*max_y): total_support_points;  % Total support points (integer)

% Constraints
% Total vehicle count must respect overall maintenance capacity
constraint
  x + y <= max_total_vehicles;

% Link total support points to per-vehicle support costs
constraint
  total_support_points = cost_x * x + cost_y * y;

% Objective
solve minimize total_support_points;