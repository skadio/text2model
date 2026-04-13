% Parameters
int: cost_solar = 50;            % Cost per unit capacity for solar ($/unit)
int: cost_wind  = 60;            % Cost per unit capacity for wind ($/unit)

int: min_total_capacity = 1000;  % Minimum combined capacity requirement (units)
int: max_threeS_minus_W = 500;   % Upper bound on (3*solar - wind) (units)

% Variables
var 0..min_total_capacity: solar_capacity;        % Solar capacity decision (whole units)
var 0..3*min_total_capacity: wind_capacity;       % Wind capacity decision (whole units)
var 0..(cost_solar*min_total_capacity + cost_wind*(3*min_total_capacity)): total_cost; % Total cost ($)

% Constraints
% Total cost definition
constraint
  total_cost = cost_solar * solar_capacity + cost_wind * wind_capacity;

% Minimum combined capacity requirement
constraint
  solar_capacity + wind_capacity >= min_total_capacity;

% Technology / project-specific limitation: 3*solar - wind <= bound
constraint
  3 * solar_capacity - wind_capacity <= max_threeS_minus_W;

% Objective
solve minimize total_cost;