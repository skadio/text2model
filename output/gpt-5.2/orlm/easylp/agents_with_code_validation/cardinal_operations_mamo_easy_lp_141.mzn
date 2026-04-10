% Parameters
int: min_units = 10;                 % Minimum total units required
int: max_firepower = 50;             % Maximum allowed firepower score
int: firepower_x = 5;                % Firepower contribution per unit X
int: firepower_y = 3;                % Firepower contribution per unit Y
int: cost_x = 1000;                  % Support points cost per unit X
int: cost_y = 2000;                  % Support points cost per unit Y

% Variables
% Upper bounds derived from max_firepower / per-unit firepower (integer division is safe here).
var 0..(max_firepower div firepower_x): x_units;    % Number of unit X (non-negative integer)
var 0..(max_firepower div firepower_y): y_units;    % Number of unit Y (non-negative integer)

% Total cost upper bound based on individual maximums (safe, possibly loose).
var 0..(cost_x * (max_firepower div firepower_x) + cost_y * (max_firepower div firepower_y)): total_cost;

% Constraints
% Strategic requirement: deploy at least the minimum number of total units
constraint
  x_units + y_units >= min_units;

% Rules of engagement: total firepower must not exceed the allowed maximum
constraint
  firepower_x * x_units + firepower_y * y_units <= max_firepower;

% Cost accounting: link total_cost to the unit allocations
constraint
  total_cost = cost_x * x_units + cost_y * y_units;

% Objective
solve minimize total_cost;