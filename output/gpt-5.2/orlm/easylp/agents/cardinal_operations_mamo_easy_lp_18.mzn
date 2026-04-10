% Parameters
int: solar_unit_cost = 50;      % $ per unit capacity for solar
int: wind_unit_cost  = 60;      % $ per unit capacity for wind

int: min_total_capacity = 1000; % minimum combined capacity requirement
int: max_diff_capacity  = 500;  % upper bound for (3*solar - wind)

% Variables
var 0..min_total_capacity: solar_capacity; % whole-number solar capacity (>= 0)

% Upper bound derived from constraints:
% wind >= min_total_capacity - solar and wind >= 3*solar - max_diff_capacity
% For solar in 0..min_total_capacity, wind never needs to exceed 3*min_total_capacity - max_diff_capacity
var 0..(3*min_total_capacity - max_diff_capacity): wind_capacity; % whole-number wind capacity (>= 0)

var int: total_cost; % total investment cost in dollars (integer)

% Constraints
% Link total_cost to the chosen capacities and unit costs
constraint
  total_cost = solar_unit_cost * solar_capacity + wind_unit_cost * wind_capacity;

% Minimum combined capacity requirement (solar + wind >= 1000)
constraint
  solar_capacity + wind_capacity >= min_total_capacity;

% Technology/project requirement: 3*solar - wind <= 500
constraint
  3 * solar_capacity - wind_capacity <= max_diff_capacity;

% Objective
solve minimize total_cost;