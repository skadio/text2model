% Parameters
int: cost_x = 50;                 % Cost per unit of production type X ($/unit)
int: cost_y = 70;                 % Cost per unit of production type Y ($/unit)
int: demand_min = 5000;           % Minimum total units required to meet demand
int: emission_x = 10;             % Emission factor for X (emission units per unit of X)
int: emission_y = 15;             % Emission factor for Y (emission units per unit of Y)
int: emission_max = 80000;        % Maximum allowed total emissions

% Variables
var 0..demand_min: x_units;       % Units produced from type X (integer, non-negative)
var 0..demand_min: y_units;       % Units produced from type Y (integer, non-negative)
var 0..(cost_y * demand_min): total_cost;  % Total cost in dollars

% Constraints
% Demand satisfaction: total production must meet or exceed the minimum demand
constraint
  x_units + y_units >= demand_min;

% Emissions limit: combined emissions from X and Y must not exceed the maximum allowed
constraint
  emission_x * x_units + emission_y * y_units <= emission_max;

% Total cost definition: link total_cost to decision variables
constraint
  total_cost = cost_x * x_units + cost_y * y_units;

% Objective
solve minimize total_cost;