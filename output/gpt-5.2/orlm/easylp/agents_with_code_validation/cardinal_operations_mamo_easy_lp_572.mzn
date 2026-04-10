% Parameters
% Total available resources
int: total_resources = 100;

% Unit costs in dollars
int: cost_x1 = 50000;
int: cost_x2 = 70000;
int: cost_x3 = 60000;

% Allocation bounds (all allocations are integers)
int: x1_min = 10;
int: x1_max = 50;

int: x2_min = 20;
int: x2_max = 70;

int: x3_min = 0;
int: x3_max = 40;

% Requirement thresholds
int: req1_gap = 20;  % left side must be >= right side + 20
int: req2_gap = 30;  % left side must be <= x1 + 30 (per interpretation below)

% Variables
var x1_min..x1_max: x1;  % resources allocated to Unit X1
var x2_min..x2_max: x2;  % resources allocated to Unit X2
var x3_min..x3_max: x3;  % resources allocated to Unit X3

% Total cost (bounded above by max allocations)
var 0..(cost_x1*x1_max + cost_x2*x2_max + cost_x3*x3_max): total_cost;

% Constraints
% Resource capacity constraint: total allocated resources cannot exceed availability
constraint
  x1 + x2 + x3 <= total_resources;

% Operational requirement 1:
% (1/2)*x1 + (6/10)*x3 >= (7/10)*x2 + req1_gap
% Scale by 10 to keep all coefficients integral: 5*x1 + 6*x3 >= 7*x2 + 10*req1_gap
constraint
  5 * x1 + 6 * x3 >= 7 * x2 + 10 * req1_gap;

% Operational requirement 2:
% Interpreted as: 0.8*x2 + 0.9*x3 <= x1 + req2_gap
% Scale by 10: 8*x2 + 9*x3 <= 10*x1 + 10*req2_gap
constraint
  8 * x2 + 9 * x3 <= 10 * x1 + 10 * req2_gap;

% Total cost definition
constraint
  total_cost = cost_x1 * x1 + cost_x2 * x2 + cost_x3 * x3;

% Objective
solve minimize total_cost;