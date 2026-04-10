% Parameters
int: total_resource_limit = 5000;                 % Maximum total available resources
int: min_effectiveness = 3000;                    % Minimum required effectiveness score
int: logistics_limit = 2500;                      % Maximum allowed logistics usage

int: eff_x1_multiplier = 4;                       % Effectiveness multiplier for X1
int: eff_x3_multiplier = 6;                       % Effectiveness multiplier for X3

int: log_x2_multiplier = 2;                       % Logistics multiplier for X2
int: log_x3_multiplier = 3;                       % Logistics multiplier for (X3/2)

int: cost_x1 = 5;                                 % Cost per unit for X1
int: cost_x2 = 3;                                 % Cost per unit for X2
int: cost_x3 = 7;                                 % Cost per unit for X3

% Variables
var 0..total_resource_limit: x1;                  % Whole-number resource allocation to project X1
var 0..total_resource_limit: x2;                  % Whole-number resource allocation to project X2
var 0..total_resource_limit: x3;                  % Whole-number resource allocation to project X3

% Upper bound: (5+3+7)*5000 = 75000
var 0..(cost_x1*total_resource_limit
      + cost_x2*total_resource_limit
      + cost_x3*total_resource_limit): total_cost; % Total cost (bounded)

% Constraints
% Resource budget limit: total allocated resources cannot exceed availability
constraint
  x1 + x2 + x3 <= total_resource_limit;

% Environmental effectiveness requirement: weighted sum must reach minimum score
constraint
  eff_x1_multiplier * x1 + eff_x3_multiplier * x3 >= min_effectiveness;

% Logistics limitation:
% Original: log_x2_multiplier*x2 + log_x3_multiplier*(x3/2) <= logistics_limit
% Multiply by 2 to keep everything integral:
% 2*log_x2_multiplier*x2 + log_x3_multiplier*x3 <= 2*logistics_limit
constraint
  (2 * log_x2_multiplier) * x2 + log_x3_multiplier * x3 <= 2 * logistics_limit;

% Total cost definition: link total_cost to decision variables
constraint
  total_cost = cost_x1 * x1 + cost_x2 * x2 + cost_x3 * x3;

% Objective
solve minimize total_cost;