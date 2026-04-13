% Parameters
int: max_total_ships = 100;        % Total ships available across both routes
int: min_capacity = 60;            % Minimum required combined capacity: 2*X + Y >= 60
int: max_route_diff = 30;          % Operational balance: |X - Y| <= 30
int: max_ships_routeX = 70;        % Upper bound for ships on Route X
int: max_ships_routeY = 50;        % Upper bound for ships on Route Y
int: cost_routeX = 10;             % Cost per ship on Route X
int: cost_routeY = 20;             % Cost per ship on Route Y

% Variables
var 0..max_ships_routeX: ships_routeX;   % Ships allocated to Route X
var 0..max_ships_routeY: ships_routeY;   % Ships allocated to Route Y
var 0..(cost_routeX*max_ships_routeX + cost_routeY*max_ships_routeY): total_cost; % Total cost

% Constraints
% Total cost definition
constraint total_cost = cost_routeX * ships_routeX + cost_routeY * ships_routeY;

% Fleet availability
constraint ships_routeX + ships_routeY <= max_total_ships;

% Minimum capacity requirement
constraint 2 * ships_routeX + ships_routeY >= min_capacity;

% Operational balance constraint
constraint abs(ships_routeX - ships_routeY) <= max_route_diff;

% Objective
solve minimize total_cost;