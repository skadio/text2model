% Parameters
int: total_capacity = 1000;          % Maximum combined units for warehouses X and Y
int: min_weighted_total = 800;       % Minimum required value of (2*X + Y)
int: max_difference = 200;           % Maximum allowed absolute difference |X - Y|
int: cost_x = 4;                     % Cost per unit allocated to warehouse X
int: cost_y = 3;                     % Cost per unit allocated to warehouse Y

% Variables
var 0..total_capacity: x_units;      % Integer units allocated to warehouse X
var 0..total_capacity: y_units;      % Integer units allocated to warehouse Y
var 0..(cost_x*total_capacity + cost_y*total_capacity): total_cost; % Total cost in dollars

% Constraints
% Total capacity constraint: combined allocation cannot exceed available resources
constraint
  x_units + y_units <= total_capacity;

% Minimum operational requirement: weighted total (2*X + Y) must be at least the threshold
constraint
  2 * x_units + y_units >= min_weighted_total;

% Balance constraint: allocation difference between warehouses must be within limits
constraint
  abs(x_units - y_units) <= max_difference;

% Cost definition constraint: total cost based on per-unit costs for each warehouse
constraint
  total_cost = cost_x * x_units + cost_y * y_units;

% Objective
solve minimize total_cost;