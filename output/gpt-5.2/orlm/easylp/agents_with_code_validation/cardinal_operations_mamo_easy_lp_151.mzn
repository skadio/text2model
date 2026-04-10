% Parameters
int: capacity_limit = 100;              % Maximum total weight (tons)
int: min_value_requirement = 150;       % Minimum required combined value (units)

int: value_per_ton_X = 2;               % Value contribution per ton of cargo X
int: value_per_ton_Y = 3;               % Value contribution per ton of cargo Y

int: cost_per_ton_X = 4;                % Cost per ton of cargo X ($)
int: cost_per_ton_Y = 5;                % Cost per ton of cargo Y ($)

% Variables
var 0..capacity_limit: x_tons;          % Tons of cargo X (integer, nonnegative)
var 0..capacity_limit: y_tons;          % Tons of cargo Y (integer, nonnegative)

var 0..(cost_per_ton_X*capacity_limit + cost_per_ton_Y*capacity_limit): total_cost;
                                        % Total cost ($), bounded by max if all capacity used

% Constraints
% Ship capacity: total weight of cargo X and Y cannot exceed the ship limit
constraint
  x_tons + y_tons <= capacity_limit;

% Business commitment: combined value must meet or exceed the minimum requirement
constraint
  value_per_ton_X * x_tons + value_per_ton_Y * y_tons >= min_value_requirement;

% Total cost definition: link total_cost to chosen tons of X and Y
constraint
  total_cost = cost_per_ton_X * x_tons + cost_per_ton_Y * y_tons;

% Objective
solve minimize total_cost;