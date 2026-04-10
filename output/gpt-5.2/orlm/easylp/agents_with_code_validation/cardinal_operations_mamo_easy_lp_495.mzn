% Parameters
int: max_weight_capacity = 500;          % Highway restriction limit: 2*X + 3*Y <= 500
int: min_total_trucks = 100;             % Demand requirement: X + Y >= 100
int: max_route_difference = 50;          % Balance requirement: |X - Y| <= 50
int: cost_route_x = 4;                   % Cost per truck on route X
int: cost_route_y = 6;                   % Cost per truck on route Y

% Variables
var 0..max_weight_capacity: trucks_x;    % Trucks assigned to route X (non-negative integer)
var 0..max_weight_capacity: trucks_y;    % Trucks assigned to route Y (non-negative integer)
var 0..(cost_route_x*max_weight_capacity + cost_route_y*max_weight_capacity): total_cost;
                                         % Total transportation cost

% Constraints
% Weight capacity restriction: 2*X + 3*Y <= max_weight_capacity
constraint 2 * trucks_x + 3 * trucks_y <= max_weight_capacity;

% Minimum demand requirement: X + Y >= min_total_trucks
constraint trucks_x + trucks_y >= min_total_trucks;

% Balance requirement: |X - Y| <= max_route_difference
constraint abs(trucks_x - trucks_y) <= max_route_difference;

% Define total transportation cost
constraint total_cost = cost_route_x * trucks_x + cost_route_y * trucks_y;

% Objective
solve minimize total_cost;