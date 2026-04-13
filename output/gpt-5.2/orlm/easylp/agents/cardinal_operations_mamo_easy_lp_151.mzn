% Parameters
int: capacity = 100;                 % Maximum total weight (tons)
int: min_value = 150;                % Minimum required combined value
int: value_per_ton_X = 2;            % Value units per ton of cargo X
int: value_per_ton_Y = 3;            % Value units per ton of cargo Y
int: cost_per_ton_X = 4;             % Cost ($) per ton of cargo X
int: cost_per_ton_Y = 5;             % Cost ($) per ton of cargo Y

% Variables
var 0..capacity: x_tons;             % Tons of cargo X (integer, nonnegative, <= capacity)
var 0..capacity: y_tons;             % Tons of cargo Y (integer, nonnegative, <= capacity)
var 0..(cost_per_ton_X*capacity + cost_per_ton_Y*capacity): total_cost;  % Total cost in dollars

% Constraints
% Capacity constraint: total shipped weight cannot exceed ship capacity
constraint x_tons + y_tons <= capacity;

% Minimum value constraint: ensure combined value commitment is met
constraint value_per_ton_X * x_tons + value_per_ton_Y * y_tons >= min_value;

% Total cost definition: link total_cost to decision variables
constraint total_cost = cost_per_ton_X * x_tons + cost_per_ton_Y * y_tons;

% Objective
solve minimize total_cost;