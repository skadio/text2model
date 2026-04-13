% Parameters
int: cost_X = 50;                 % Cost per building of type X (dollars)
int: cost_Y = 70;                 % Cost per building of type Y (dollars)

int: contrib_X = 5;               % Contribution per X building to the minimum requirement
int: contrib_Y = 10;              % Contribution per Y building to the minimum requirement
int: min_total_contrib = 100;     % Minimum required total contribution

int: max_buildings = 20;          % Maximum number of buildings (X + Y)

% Variables
var 0..max_buildings: x;          % Number of type X buildings (integer, nonnegative)
var 0..max_buildings: y;          % Number of type Y buildings (integer, nonnegative)

% Upper bound: worst case all max_buildings are of the more expensive type, but keep a safe bound
var 0..(cost_X*max_buildings + cost_Y*max_buildings): total_cost;  % Total cost (dollars)

% Constraints
% Link total_cost to decision variables (compute total project cost)
constraint total_cost = cost_X * x + cost_Y * y;

% Minimum total contribution requirement (manpower/equipment/time)
constraint contrib_X * x + contrib_Y * y >= min_total_contrib;

% Resource limit: total number of buildings cannot exceed maximum available
constraint x + y <= max_buildings;

% Objective
solve minimize total_cost;