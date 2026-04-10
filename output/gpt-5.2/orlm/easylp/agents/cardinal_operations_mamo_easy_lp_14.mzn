% Parameters
int: cost_x = 50;            % Cost per unit of production type X ($/unit)
int: cost_y = 70;            % Cost per unit of production type Y ($/unit)
int: demand_min = 5000;      % Minimum total units required
int: emit_x = 10;            % Emission factor per unit of X
int: emit_y = 15;            % Emission factor per unit of Y
int: emission_max = 80000;   % Maximum allowed combined emissions

% Variables
var 0..demand_min: x_units;                     % Units produced from type X (nonnegative integer)
var 0..demand_min: y_units;                     % Units produced from type Y (nonnegative integer)
var 0..(cost_y * demand_min): total_cost;       % Total cost in dollars (bounded)

% Constraints
% Demand satisfaction: total production must meet or exceed minimum demand
constraint
  x_units + y_units >= demand_min;

% Emissions cap: combined emissions from X and Y must not exceed the maximum allowed
constraint
  emit_x * x_units + emit_y * y_units <= emission_max;

% Total cost definition: link total_cost to production decisions
constraint
  total_cost = cost_x * x_units + cost_y * y_units;

% Objective
solve minimize total_cost;