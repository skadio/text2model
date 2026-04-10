% Parameters
int: max_total_resources = 50;        % Total resources available for X and Y combined
int: min_effectiveness = 30;          % Minimum required effectiveness score
int: max_balance_deviation = 10;      % Maximum allowed deviation for balance constraint
int: cost_per_x = 5;                  % Cost per unit of resource allocated to service X
int: cost_per_y = 10;                 % Cost per unit of resource allocated to service Y

% Variables
var 0..max_total_resources: x;        % Integer resources allocated to service X
var 0..max_total_resources: y;        % Integer resources allocated to service Y

% Constraints
% Resource budget: total allocation cannot exceed available resources
constraint x + y <= max_total_resources;

% Minimum effectiveness requirement: 2*x + y must reach the threshold
constraint 2 * x + y >= min_effectiveness;

% Balance constraint: |x - 2*y| must not exceed the allowed deviation
constraint abs(x - 2 * y) <= max_balance_deviation;

% Objective
solve minimize cost_per_x * x + cost_per_y * y;