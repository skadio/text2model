% Parameters
int: medium_toys_per_day = 50;         % Toys produced per day by one medium factory
int: medium_operators_required = 3;    % Operators required for one medium factory

int: small_toys_per_day = 35;          % Toys produced per day by one small factory
int: small_operators_required = 2;     % Operators required for one small factory

int: min_toys_per_day = 250;           % Minimum required toy production per day
int: max_operators_available = 16;     % Maximum available operators

% Upper bounds derived from operator constraint (keeps decision vars bounded)
int: max_medium_factories = max_operators_available div medium_operators_required;
int: max_small_factories  = max_operators_available div small_operators_required;

% Variables
var 0..max_medium_factories: n_medium; % Number of medium factories to build
var 0..max_small_factories:  n_small;  % Number of small factories to build

var 0..(max_medium_factories + max_small_factories): total_factories; % Total factories built

% Constraints
% Total factories definition
constraint total_factories = n_medium + n_small;

% Minimum daily toy production requirement
constraint
  medium_toys_per_day * n_medium + small_toys_per_day * n_small >= min_toys_per_day;

% Operator availability limit
constraint
  medium_operators_required * n_medium + small_operators_required * n_small <= max_operators_available;

% Objective
solve minimize total_factories;