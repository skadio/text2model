% Parameters
int: max_total_ships = 1000;          % Fleet size limit across all routes
int: min_service_level = 500;         % Minimum required for 2*X + Y
int: max_diff_yz = 300;               % Maximum allowed absolute difference |Y - Z|
int: cost_x = 2;                      % Cost per ship on route X
int: cost_y = 3;                      % Cost per ship on route Y
int: cost_z = 4;                      % Cost per ship on route Z

% Variables
var 0..max_total_ships: ships_x;      % Number of ships allocated to route X
var 0..max_total_ships: ships_y;      % Number of ships allocated to route Y
var 0..max_total_ships: ships_z;      % Number of ships allocated to route Z

% Total operational cost (tight enough upper bound)
var 0..(cost_x*max_total_ships + cost_y*max_total_ships + cost_z*max_total_ships): total_cost;

% Constraints
% Fleet size limit across all routes
constraint ships_x + ships_y + ships_z <= max_total_ships;

% Service obligation: ensure sufficient allocation on X and Y
constraint 2 * ships_x + ships_y >= min_service_level;

% Balance constraint: keep allocations on Y and Z within allowed difference
constraint abs(ships_y - ships_z) <= max_diff_yz;

% Total operational cost definition (linking variable to per-route costs)
constraint total_cost = cost_x * ships_x + cost_y * ships_y + cost_z * ships_z;

% Objective
solve minimize total_cost;