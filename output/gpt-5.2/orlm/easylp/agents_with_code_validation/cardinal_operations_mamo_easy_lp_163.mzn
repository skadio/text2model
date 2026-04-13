% Parameters
int: cost_x = 50000;                 % Cost per unit of property type X (dollars)
int: cost_y = 80000;                 % Cost per unit of property type Y (dollars)
int: max_total_units = 10;           % Zoning limit on total number of properties
int: max_x_units = 7;                % Land size limit on number of X units
int: max_y_units = 6;                % Land size limit on number of Y units
int: extra_x_over_half_y = 3;        % Diversification offset: X >= (Y/2) + 3

% Variables
var 0..max_x_units: x_units;         % Number of type X properties (integer units)
var 0..max_y_units: y_units;         % Number of type Y properties (integer units)
var 0..(cost_x*max_x_units + cost_y*max_y_units): total_cost; % Total cost (dollars)

% Constraints
% Total cost definition (linking decision variables to total_cost)
constraint
  total_cost = cost_x * x_units + cost_y * y_units;

% Zoning regulation: total number of units cannot exceed the maximum allowed
constraint
  x_units + y_units <= max_total_units;

% Diversification requirement:
% x_units must be at least half of y_units plus an additional offset.
% Use integer arithmetic to avoid coercion: 2*x_units >= y_units + 2*extra
constraint
  2 * x_units >= y_units + 2 * extra_x_over_half_y;

% Objective
solve minimize total_cost;