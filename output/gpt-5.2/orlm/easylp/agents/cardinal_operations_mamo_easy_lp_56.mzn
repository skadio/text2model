% Parameters
int: total_shelf_space = 2000;          % Total available shelf space (units)
int: min_demand = 500;                  % Minimum demand constraint RHS for 2*X + Y
int: max_diff = 1000;                   % Maximum allowed absolute difference |X - 2*Y|
int: cost_per_unit_x = 2;               % Cost per unit shelf space for product X ($/unit)
int: cost_per_unit_y = 3;               % Cost per unit shelf space for product Y ($/unit)

% Variables
var 0..total_shelf_space: shelf_x;      % Shelf space allocated to product X (units, integer)
var 0..total_shelf_space: shelf_y;      % Shelf space allocated to product Y (units, integer)
var 0..(cost_per_unit_x*total_shelf_space + cost_per_unit_y*total_shelf_space): total_cost; % Total cost ($, integer)

% Constraints
% Link total_cost to allocated shelf spaces and unit costs
constraint
  total_cost = cost_per_unit_x * shelf_x + cost_per_unit_y * shelf_y;

% Total shelf space capacity constraint
constraint
  shelf_x + shelf_y <= total_shelf_space;

% Minimum demand constraint: 2*X + Y must be at least min_demand
constraint
  2 * shelf_x + shelf_y >= min_demand;

% Balanced display constraint: absolute difference |X - 2*Y| cannot exceed max_diff
constraint
  abs(shelf_x - 2 * shelf_y) <= max_diff;

% Objective
solve minimize total_cost;