% Parameters
int: max_total_ships = 1000;        % Maximum fleet size across all routes
int: min_service_requirement = 500; % Minimum required value for 2*X + Y
int: max_yz_diff = 300;             % Maximum allowed absolute difference |Y - Z|

int: cost_x = 2;                    % Cost per ship on route X
int: cost_y = 3;                    % Cost per ship on route Y
int: cost_z = 4;                    % Cost per ship on route Z

% Variables
var 0..max_total_ships: ships_x;    % Ships allocated to route X
var 0..max_total_ships: ships_y;    % Ships allocated to route Y
var 0..max_total_ships: ships_z;    % Ships allocated to route Z

% Upper bound: worst-case cost if all ships were assigned to the most expensive route
var 0..(cost_x*max_total_ships + cost_y*max_total_ships + cost_z*max_total_ships): total_cost;

% Constraints
% Fleet size limit across all routes
constraint ships_x + ships_y + ships_z <= max_total_ships;

% Service obligation: ensure sufficient combined allocation on routes X and Y
constraint 2 * ships_x + ships_y >= min_service_requirement;

% Balance constraint: limit the absolute difference between route Y and route Z allocations
constraint abs(ships_y - ships_z) <= max_yz_diff;

% Define total operational cost from per-route costs and allocations
constraint total_cost = cost_x * ships_x + cost_y * ships_y + cost_z * ships_z;

% Objective
solve minimize total_cost;