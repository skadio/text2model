% Parameters
int: total_resource_limit = 100;                 % Maximum total resources available

int: cost_x1 = 50000;                            % Cost per resource unit for Unit X1 ($)
int: cost_x2 = 70000;                            % Cost per resource unit for Unit X2 ($)
int: cost_x3 = 60000;                            % Cost per resource unit for Unit X3 ($)

int: x1_min = 10; int: x1_max = 50;              % Allocation bounds for Unit X1
int: x2_min = 20; int: x2_max = 70;              % Allocation bounds for Unit X2
int: x3_min = 0;  int: x3_max = 40;              % Allocation bounds for Unit X3

int: req1_rhs_margin = 20;                       % Requirement 1 margin
int: req2_rhs_margin = 30;                       % Requirement 2 margin


% Variables
var x1_min..x1_max: x1;                          % Resources allocated to Unit X1 (integer)
var x2_min..x2_max: x2;                          % Resources allocated to Unit X2 (integer)
var x3_min..x3_max: x3;                          % Resources allocated to Unit X3 (integer)

var 0..(cost_x1*x1_max + cost_x2*x2_max + cost_x3*x3_max): total_cost;  % Total cost ($)


% Constraints

% Resource capacity constraint: total allocated resources cannot exceed the limit
constraint
  x1 + x2 + x3 <= total_resource_limit;

% Operational requirement 1:
% 0.5*x1 + 0.6*x3 >= 0.7*x2 + req1_rhs_margin
% Scaled by 10 to keep integer arithmetic: 5*x1 + 6*x3 >= 7*x2 + 10*margin
constraint
  5 * x1 + 6 * x3 >= 7 * x2 + 10 * req1_rhs_margin;

% Operational requirement 2:
% 0.8*x2 + 0.9*x3 <= x1 - req2_rhs_margin
% Scaled by 10: 8*x2 + 9*x3 <= 10*x1 - 10*margin
constraint
  8 * x2 + 9 * x3 <= 10 * x1 - 10 * req2_rhs_margin;

% Total cost definition (kept separate for clarity and reuse in objective)
constraint
  total_cost = cost_x1 * x1 + cost_x2 * x2 + cost_x3 * x3;


% Objective
solve minimize total_cost;