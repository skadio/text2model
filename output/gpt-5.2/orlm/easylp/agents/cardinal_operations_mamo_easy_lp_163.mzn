% Parameters
int: cost_X = 50000;                 % Cost per unit of property type X (dollars)
int: cost_Y = 80000;                 % Cost per unit of property type Y (dollars)
int: max_total_units = 10;           % Zoning limit on total number of properties
int: max_X = 7;                      % Land parcel limit on number of X units
int: max_Y = 6;                      % Land parcel limit on number of Y units
int: extra_X_over_half_Y = 3;        % X must be at least half of Y plus this many units

% Variables
var 0..max_X: x_units;               % Number of type X properties to build (integer units)
var 0..max_Y: y_units;               % Number of type Y properties to build (integer units)
var 0..(cost_X*max_X + cost_Y*max_Y): total_cost; % Total cost (dollars)

% Constraints
% Total units zoning limit
constraint
  x_units + y_units <= max_total_units;

% Portfolio diversification rule:
% X must be at least half of Y plus an additional fixed amount.
% Implemented without fractional arithmetic to keep everything integral: 2*X >= Y + 2*extra
constraint
  2 * x_units >= y_units + 2 * extra_X_over_half_Y;

% Define total cost from unit decisions
constraint
  total_cost = cost_X * x_units + cost_Y * y_units;

% Objective
solve minimize total_cost;