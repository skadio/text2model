% Parameters
% Unit costs per resource unit for each project
float: cost_x1 = 0.5;
float: cost_x2 = 0.3;
float: cost_x3 = 0.4;
float: cost_x4 = 0.6;

% Bounds on resource allocations (whole units)
int: x1_min = 0;
int: x1_max = 400;

int: x2_min = 0;
int: x2_max = 300;

int: x3_min = 50;
int: x3_max = 200;

int: x4_min = 30;
int: x4_max = 60;

% Constraint constants
int: cap_x1_x2 = 500;        % x1 + x2 <= 500
int: req_2x1_3x3 = 300;      % 2*x1 + 3*x3 >= 300
int: x4_over_half_x2 = 100;  % x4 <= x2/2 + 100  (encoded as 2*x4 - x2 <= 200)
int: balance_eq = 80;        % x2 + x4 - x1 - x3 = 80


% Variables
var x1_min..x1_max: x1;   % Resources allocated to project x1
var x2_min..x2_max: x2;   % Resources allocated to project x2
var x3_min..x3_max: x3;   % Resources allocated to project x3
var x4_min..x4_max: x4;   % Resources allocated to project x4

% Total cost (not necessarily integer due to fractional unit costs)
var float: total_cost;

% Rounded-off minimum total cost (nearest integer)
var int: rounded_total_cost;


% Constraints
% Capacity constraint: combined allocation to x1 and x2 cannot exceed cap
constraint
  x1 + x2 <= cap_x1_x2;

% Implementation requirement: 2*x1 + 3*x3 must be at least the required level
constraint
  2 * x1 + 3 * x3 >= req_2x1_3x3;

% Relationship constraint: integer-safe form avoiding division
% Equivalent to: x4 <= x2/2 + x4_over_half_x2
constraint
  2 * x4 - x2 <= 2 * x4_over_half_x2;

% Balance constraint: must hold exactly
constraint
  x2 + x4 - x1 - x3 = balance_eq;

% Define total cost from unit costs and allocations (int->float coercion via int2float)
constraint
  total_cost =
      cost_x1 * int2float(x1)
    + cost_x2 * int2float(x2)
    + cost_x3 * int2float(x3)
    + cost_x4 * int2float(x4);

% Rounded-off total cost (nearest integer)
constraint
  rounded_total_cost = round(total_cost);


% Objective
solve minimize rounded_total_cost;