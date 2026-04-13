% Parameters
int: cost_x = 5;                 % Cost per unit allocation for project X
int: cost_y = 8;                 % Cost per unit allocation for project Y

int: max_resource = 50;          % Upper limit for x + 2*y
int: min_total_allocation = 10;  % Lower limit for x + y
int: diff_limit = 20;            % Upper limit for (y - x/2)

int: x_lb = 0;                   % Lower bound for allocation to X
int: x_ub = 25;                  % Upper bound for allocation to X
int: y_lb = 0;                   % Lower bound for allocation to Y
int: y_ub = 30;                  % Upper bound for allocation to Y


% Variables
var x_lb..x_ub: x;               % Integer resource allocation to project X
var y_lb..y_ub: y;               % Integer resource allocation to project Y

var int: total_cost;             % Total cost to minimize


% Constraints
% Resource capacity constraint: x + 2*y <= max_resource
constraint
  x + 2 * y <= max_resource;

% Minimum combined allocation constraint: x + y >= min_total_allocation
constraint
  x + y >= min_total_allocation;

% Difference/imbalance constraint: y - x/2 <= diff_limit
% Avoid fractional division by multiplying both sides by 2: 2*y - x <= 2*diff_limit
constraint
  2 * y - x <= 2 * diff_limit;

% Total cost definition constraint
constraint
  total_cost = cost_x * x + cost_y * y;


% Objective
solve minimize total_cost;