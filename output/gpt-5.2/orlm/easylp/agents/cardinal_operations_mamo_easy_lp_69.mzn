% Parameters
int: cost_X = 5;              % Cost per unit of crop X
int: cost_Y = 10;             % Cost per unit of crop Y

int: min_production = 200;    % Minimum required production for 2*X + Y
int: max_capacity = 150;      % Maximum allowed capacity for X + 3*Y

% Coefficients in constraints
int: a1_X = 2;                % Coefficient of X in production constraint
int: a1_Y = 1;                % Coefficient of Y in production constraint
int: a2_X = 1;                % Coefficient of X in capacity constraint
int: a2_Y = 3;                % Coefficient of Y in capacity constraint


% Variables
var 0..max_capacity: x;       % Units of crop X (non-negative integer, bounded)
var 0..max_capacity: y;       % Units of crop Y (non-negative integer, bounded)

var 0..(cost_X*max_capacity + cost_Y*max_capacity): total_cost;  % Total planting cost


% Constraints
% Link total_cost to decision variables (linear cost accounting)
constraint
  total_cost = cost_X * x + cost_Y * y;

% Minimum production requirement: a1_X*x + a1_Y*y >= min_production
constraint
  a1_X * x + a1_Y * y >= min_production;

% Maximum capacity limitation: a2_X*x + a2_Y*y <= max_capacity
constraint
  a2_X * x + a2_Y * y <= max_capacity;


% Objective
solve minimize total_cost;