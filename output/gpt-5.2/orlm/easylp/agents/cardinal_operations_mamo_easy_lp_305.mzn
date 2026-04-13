% Parameters
int: total_resource_limit = 5000;              % Maximum total resources available
int: min_effectiveness = 3000;                 % Minimum required effectiveness score
int: logistic_limit = 2500;                    % Maximum allowed logistic usage

int: cost_x1 = 5;                              % Cost per unit for project X1
int: cost_x2 = 3;                              % Cost per unit for project X2
int: cost_x3 = 7;                              % Cost per unit for project X3

int: eff_mult_x1 = 4;                          % Effectiveness multiplier for X1
int: eff_mult_x3 = 6;                          % Effectiveness multiplier for X3

int: log_mult_x2 = 2;                          % Logistic multiplier for X2 term
% "thrice the half resources for X3" = 3 * (X3/2) = (3/2)*X3, model as 3*X3 <= 2*limit
int: log_half_mult_x3_num = 3;                 % Numerator for (3/2)*X3
int: log_half_mult_x3_den = 2;                 % Denominator for (3/2)*X3

% Variables
var 0..total_resource_limit: x1;               % Integer resources allocated to project X1
var 0..total_resource_limit: x2;               % Integer resources allocated to project X2
var 0..total_resource_limit: x3;               % Integer resources allocated to project X3

var 0..(cost_x1*total_resource_limit
      + cost_x2*total_resource_limit
      + cost_x3*total_resource_limit): total_cost;  % Total cost to minimize

% Constraints

% --- Total resource budget constraint ---
% The sum of resources allocated across all projects cannot exceed the total limit.
constraint
  x1 + x2 + x3 <= total_resource_limit;

% --- Minimum effectiveness constraint ---
% Combined effectiveness from X1 and X3 must reach at least the minimum threshold.
constraint
  eff_mult_x1 * x1 + eff_mult_x3 * x3 >= min_effectiveness;

% --- Logistic limitation constraint ---
% 2*X2 + (3/2)*X3 <= logistic_limit
% Avoid fractional coefficients by multiplying through by the denominator:
% (2*den)*X2 + num*X3 <= (den)*logistic_limit
constraint
  (log_mult_x2 * log_half_mult_x3_den) * x2 + log_half_mult_x3_num * x3
  <= log_half_mult_x3_den * logistic_limit;

% --- Total cost definition constraint ---
% Total cost is determined by per-unit costs and allocations.
constraint
  total_cost = cost_x1 * x1 + cost_x2 * x2 + cost_x3 * x3;

% Objective
solve minimize total_cost;