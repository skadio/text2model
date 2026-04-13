% Parameters
int: total_bandwidth = 10000;              % Maximum combined bandwidth for X and Y
int: min_x_minus_half_y = 3000;            % Constraint: x - 0.5*y >= 3000 (scaled later)
int: max_y_minus_three_quarters_x = 2000;  % Constraint: y - 0.75*x <= 2000 (scaled later)
int: cost_per_unit_x = 20;                 % Cost per unit bandwidth for service X
int: cost_per_unit_y = 30;                 % Cost per unit bandwidth for service Y

% Variables
var 0..total_bandwidth: x;                 % Bandwidth allocated to service X (integer, nonnegative)
var 0..total_bandwidth: y;                 % Bandwidth allocated to service Y (integer, nonnegative)
var 0..(cost_per_unit_y * total_bandwidth): total_cost; % Total cost upper bound

% Constraints
% Total bandwidth capacity constraint
constraint x + y <= total_bandwidth;

% Service quality constraint: x - 0.5*y >= 3000
% Scale by 2 to avoid fractional coefficients: 2x - y >= 6000
constraint 2 * x - y >= 2 * min_x_minus_half_y;

% Balance constraint: y - 0.75*x <= 2000
% Scale by 4 to avoid fractional coefficients: 4y - 3x <= 8000
constraint 4 * y - 3 * x <= 4 * max_y_minus_three_quarters_x;

% Define total cost
constraint total_cost = cost_per_unit_x * x + cost_per_unit_y * y;

% Objective
solve minimize total_cost;