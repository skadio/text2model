% Parameters
int: max_ships = 1000;                % Maximum total number of ships available
int: min_capacity = 800;              % Minimum required combined capacity
int: max_capacity_diff = 200;         % Maximum allowed difference: X - (Y/2) <= 200
int: cost_x = 8;                      % Cost per unit of ship type X
int: cost_y = 15;                     % Cost per unit of ship type Y

% Variables
var 0..max_ships: x_ships;            % Number of ship type X allocated (integer, nonnegative)
var 0..max_ships: y_ships;            % Number of ship type Y allocated (integer, nonnegative)
var 0..(cost_x*max_ships + cost_y*max_ships): total_cost; % Total operational cost

% Constraints
% Fleet size limit: total ships cannot exceed available capacity
constraint
  x_ships + y_ships <= max_ships;

% Minimum capacity requirement: 2*X + Y must meet or exceed required capacity
constraint
  2 * x_ships + y_ships >= min_capacity;

% Capacity difference limit without fractions:
% X - (Y/2) <= max_diff  <=>  2*X - Y <= 2*max_diff
constraint
  2 * x_ships - y_ships <= 2 * max_capacity_diff;

% Define total operational cost from allocations
constraint
  total_cost = cost_x * x_ships + cost_y * y_ships;

% Objective
solve minimize total_cost;