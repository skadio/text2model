% Parameters
% Per-employee salary costs for each department
int: cost_x1 = 50;                 % salary cost per employee in department x1
int: cost_x2 = 40;                 % salary cost per employee in department x2
int: cost_x3 = 30;                 % salary cost per employee in department x3
int: cost_x4 = 20;                 % salary cost per employee in department x4

% Constraint thresholds
int: min_x1_plus_x2 = 15;          % x1 + x2 >= 15
int: max_x2_plus_x3 = 25;          % x2 + x3 <= 25
int: min_x3_minus_x4 = 5;          % x3 - x4 >= 5
int: max_x1_minus_2x4 = 10;        % x1 - 2*x4 <= 10


% Variables
% Number of employees in each department (nonnegative integers)
var 0..1000: x1;
var 0..1000: x2;
var 0..1000: x3;
var 0..1000: x4;

% Total salary cost (objective value)
var 0..1000000000: total_cost;


% Constraints
% Manpower requirement: departments x1 and x2 combined must meet minimum staffing
constraint x1 + x2 >= min_x1_plus_x2;

% Capacity/budget limitation: departments x2 and x3 combined must not exceed maximum staffing
constraint x2 + x3 <= max_x2_plus_x3;

% Staffing difference requirement: x3 must exceed x4 by at least a given margin
constraint x3 - x4 >= min_x3_minus_x4;

% Balance constraint: x1 minus twice x4 must not exceed the allowed maximum
constraint x1 - 2 * x4 <= max_x1_minus_2x4;

% Total cost definition: link total_cost to decision variables and per-employee costs
constraint total_cost = cost_x1 * x1 + cost_x2 * x2 + cost_x3 * x3 + cost_x4 * x4;


% Objective
solve minimize total_cost;