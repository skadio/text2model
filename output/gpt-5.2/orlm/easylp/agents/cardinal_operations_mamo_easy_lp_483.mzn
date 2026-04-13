% Parameters
int: max_budget = 100;                 % Maximum allowed for 4*x + 5*y
int: min_total_allocation = 20;        % Minimum required for x + y
int: max_balance_diff = 30;            % Maximum allowed for |2*x - y|

int: budget_coeff_x = 4;               % Coefficient of x in budget constraint
int: budget_coeff_y = 5;               % Coefficient of y in budget constraint
int: balance_coeff_x = 2;              % Coefficient of x in balance expression

int: cost_x = 6;                       % Unit cost for project X
int: cost_y = 2;                       % Unit cost for project Y

% Derived bounds (tight, integer upper bounds from constraints)
int: x_ub = max_budget div budget_coeff_x;        % since 4*x <= 100 -> x <= 25
int: y_ub = max_budget div budget_coeff_y;        % since 5*y <= 100 -> y <= 20

% Variables
var 0..x_ub: x;                        % Integer allocation to project X
var 0..y_ub: y;                        % Integer allocation to project Y

var 0..(cost_x * x_ub + cost_y * y_ub): total_cost;  % Total cost to minimize

% Constraints

% Budget feasibility: respect maximum allowed weighted allocation
constraint
  budget_coeff_x * x + budget_coeff_y * y <= max_budget;

% Minimum total allocation: ensure sufficient combined impact
constraint
  x + y >= min_total_allocation;

% Balance requirement: keep the approach balanced between projects
constraint
  abs(balance_coeff_x * x - y) <= max_balance_diff;

% Total cost definition: link decision variables to total_cost
constraint
  total_cost = cost_x * x + cost_y * y;

% Objective
solve minimize total_cost;