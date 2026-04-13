% Parameters
int: max_total_ships = 100;          % Maximum number of ships that can be deployed in total
int: min_capacity_required = 60;     % Minimum required combined capacity (2*X + Y)
int: max_route_diff = 30;            % Maximum allowed absolute difference between Route X and Route Y
int: cost_route_x = 10;              % Cost per ship on Route X
int: cost_route_y = 20;              % Cost per ship on Route Y
int: max_ships_route_x = 70;         % Upper bound on ships allocated to Route X
int: max_ships_route_y = 50;         % Upper bound on ships allocated to Route Y

% Variables
var 0..max_ships_route_x: ships_x;   % Ships allocated to Route X
var 0..max_ships_route_y: ships_y;   % Ships allocated to Route Y
var 0..(cost_route_x*max_ships_route_x + cost_route_y*max_ships_route_y): total_cost; % Total cost

% Constraints
% Total fleet size limit across both routes
constraint ships_x + ships_y <= max_total_ships;

% Demand/capacity requirement: combined capacity 2*X + Y must meet minimum
constraint 2 * ships_x + ships_y >= min_capacity_required;

% Operational balance: routes' allocations cannot differ by more than allowed
constraint abs(ships_x - ships_y) <= max_route_diff;

% Total cost definition from per-route costs and allocations
constraint total_cost = cost_route_x * ships_x + cost_route_y * ships_y;

% Objective
solve minimize total_cost;

output [
  "ships_x = ", show(ships_x), "\n",
  "ships_y = ", show(ships_y), "\n",
  "total_cost = ", show(total_cost), "\n"
];