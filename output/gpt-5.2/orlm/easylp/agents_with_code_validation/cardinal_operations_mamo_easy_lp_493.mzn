% Parameters
int: max_vessels = 100;              % Port capacity limit on total vessels
int: min_capacity = 50;              % Minimum required operational capacity
int: max_diff = 20;                  % Maximum allowed absolute difference between X and Y

int: cap_x = 2;                      % Capacity contribution per type X vessel
int: cap_y = 3;                      % Capacity contribution per type Y vessel

int: cost_x = 3;                     % Daily operating cost per type X vessel ($)
int: cost_y = 2;                     % Daily operating cost per type Y vessel ($)

% Variables
var 0..max_vessels: num_x;           % Number of type X vessels (integer, non-negative)
var 0..max_vessels: num_y;           % Number of type Y vessels (integer, non-negative)

var 0..(cost_x*max_vessels + cost_y*max_vessels): total_cost;  % Total daily operating cost ($)

% Constraints
% Total vessels cannot exceed port capacity
constraint num_x + num_y <= max_vessels;

% Service level: ensure minimum operational capacity is met
constraint cap_x * num_x + cap_y * num_y >= min_capacity;

% Balanced fleet: absolute difference between vessel counts limited
constraint abs(num_x - num_y) <= max_diff;

% Define total daily operating cost from vessel counts
constraint total_cost = cost_x * num_x + cost_y * num_y;

% Objective
solve minimize total_cost;