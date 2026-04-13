% Parameters
int: cost_x = 50;                 % Cost per unit of building type X ($)
int: cost_y = 70;                 % Cost per unit of building type Y ($)

int: contrib_x = 5;               % Contribution to requirement per unit of X
int: contrib_y = 10;              % Contribution to requirement per unit of Y
int: min_total_contrib = 100;     % Minimum total contribution required

int: max_buildings = 20;          % Maximum total number of buildings (X + Y)

% Variables
var 0..max_buildings: x;          % Number of buildings of type X (integer, non-negative)
var 0..max_buildings: y;          % Number of buildings of type Y (integer, non-negative)

% Upper bound: worst-case if all buildings are the more expensive type
var 0..(max_buildings * max(cost_x, cost_y)): total_cost;  % Total cost ($)

% Constraints
% Resource capacity: total number of buildings cannot exceed the maximum allowed
constraint x + y <= max_buildings;

% Minimum required total contribution from all constructed buildings
constraint contrib_x * x + contrib_y * y >= min_total_contrib;

% Total cost definition based on numbers of each building type
constraint total_cost = cost_x * x + cost_y * y;

% Objective
solve minimize total_cost;