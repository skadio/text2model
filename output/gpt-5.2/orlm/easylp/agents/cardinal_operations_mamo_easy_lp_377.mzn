% Parameters
% Salary cost per employee in each department
int: cost_x1 = 50;
int: cost_x2 = 40;
int: cost_x3 = 30;
int: cost_x4 = 20;

% Constraint right-hand sides / constants
int: min_x1_x2 = 15;        % x1 + x2 >= 15
int: max_x2_x3 = 25;        % x2 + x3 <= 25
int: min_x3_minus_x4 = 5;   % x3 - x4 >= 5
int: max_x1_minus_2x4 = 10; % x1 - 2*x4 <= 10


% Variables
% Number of employees allocated to each department (whole numbers, non-negative)
var int: x1;
var int: x2;
var int: x3;
var int: x4;

% Total salary cost (in dollars)
var int: total_cost;


% Constraints
% Basic non-negativity bounds
constraint x1 >= 0;
constraint x2 >= 0;
constraint x3 >= 0;
constraint x4 >= 0;

% Link total cost to allocations
constraint total_cost = cost_x1 * x1 + cost_x2 * x2 + cost_x3 * x3 + cost_x4 * x4;

% Manpower requirement: departments x1 and x2 combined must be at least the minimum
constraint x1 + x2 >= min_x1_x2;

% Capacity/budget limitation: departments x2 and x3 combined cannot exceed the maximum
constraint x2 + x3 <= max_x2_x3;

% Staffing balance: department x3 must exceed department x4 by at least the given amount
constraint x3 - x4 >= min_x3_minus_x4;

% Difference limitation: x1 minus twice x4 should not exceed the allowed maximum
constraint x1 - 2 * x4 <= max_x1_minus_2x4;


% Objective
solve minimize total_cost;