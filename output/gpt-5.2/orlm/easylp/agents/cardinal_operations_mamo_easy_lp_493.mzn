% Parameters
int: max_vessels = 100;                 % Maximum combined number of vessels in service
int: min_capacity = 50;                % Minimum required operational capacity
int: max_type_diff = 20;               % Maximum allowed absolute difference between X and Y

int: cap_x = 2;                        % Capacity contribution per type X vessel
int: cap_y = 3;                        % Capacity contribution per type Y vessel

int: cost_x = 3;                       % Daily operating cost per type X vessel (dollars)
int: cost_y = 2;                       % Daily operating cost per type Y vessel (dollars)

% Variables
var 0..max_vessels: x;                 % Number of type X vessels (integer, nonnegative)
var 0..max_vessels: y;                 % Number of type Y vessels (integer, nonnegative)

var 0..(cost_x*max_vessels + cost_y*max_vessels): total_cost; % Total daily operating cost (dollars)

% Constraints
% Fleet size (port capacity) constraint: combined number of vessels cannot exceed max_vessels
constraint x + y <= max_vessels;

% Service level (minimum operational capacity) constraint
constraint cap_x * x + cap_y * y >= min_capacity;

% Fleet balance constraint: absolute difference between X and Y cannot exceed max_type_diff
constraint abs(x - y) <= max_type_diff;

% Total cost definition constraint
constraint total_cost = cost_x * x + cost_y * y;

% Objective
solve minimize total_cost;