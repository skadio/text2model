% Parameters
int: max_total_ships = 1000;          % Upper bound on total number of ships
int: min_required_capacity = 800;     % Minimum required combined capacity
int: max_capacity_difference = 200;   % Maximum allowed difference constraint
int: cost_per_ship_x = 8;             % Cost per ship type X
int: cost_per_ship_y = 15;            % Cost per ship type Y

% Variables
var 0..max_total_ships: ships_x;      % Number of ship type X allocated (integer, nonnegative)
var 0..max_total_ships: ships_y;      % Number of ship type Y allocated (integer, nonnegative)

% Total operational cost (bounded by worst case: all ships are of the more expensive type)
var 0..(cost_per_ship_x*max_total_ships + cost_per_ship_y*max_total_ships): total_cost;

% Constraints
% --- Fleet size limit ---
constraint ships_x + ships_y <= max_total_ships;

% --- Minimum required combined capacity: 2*X + Y >= 800 ---
constraint 2 * ships_x + ships_y >= min_required_capacity;

% --- Capacity difference constraint: X - (Y/2) <= 200 ---
% Multiply by 2 to keep everything integral and avoid division on vars:
% 2*X - Y <= 2*200
constraint 2 * ships_x - ships_y <= 2 * max_capacity_difference;

% --- Total cost definition ---
constraint total_cost = cost_per_ship_x * ships_x + cost_per_ship_y * ships_y;

% Objective
solve minimize total_cost;