% Parameters
% Unit costs for each project
int: cost_x1 = 10;
int: cost_x2 = 20;
int: cost_x3 = 30;
int: cost_x4 = 40;

% Constraint constants
int: max_x1_plus_x2 = 50;     % x1 + x2 <= 50
int: min_x3_minus_x4 = 10;    % x3 >= x4 + 10
int: max_2x1_plus_x3 = 60;    % 2*x1 + x3 <= 60
int: min_x2_minus_2x4 = 5;    % x2 >= 2*x4 + 5

% Variables
% Decision variables: integer number of units for each project (nonnegative)
var 0..max_x1_plus_x2: x1;            % safe bound given x1 + x2 <= 50
var 0..max_x1_plus_x2: x2;            % safe bound given x1 + x2 <= 50
var 0..max_2x1_plus_x3: x3;           % safe bound given 2*x1 + x3 <= 60
var 0..max_2x1_plus_x3: x4;           % safe bound (x4 <= x3 - 10 <= 50); 0..60 is safe

% Total cost (integer)
int: max_total_cost =
  cost_x1 * max_x1_plus_x2 +
  cost_x2 * max_x1_plus_x2 +
  cost_x3 * max_2x1_plus_x3 +
  cost_x4 * max_2x1_plus_x3;

var 0..max_total_cost: total_cost;

% Constraints
% Budgetary limitation: combined units of x1 and x2 cannot exceed the maximum
constraint x1 + x2 <= max_x1_plus_x2;

% Strategic priority: x3 must be at least 10 units more than x4
constraint x3 - x4 >= min_x3_minus_x4;

% Resource limitation: twice x1 plus x3 cannot exceed the maximum
constraint 2 * x1 + x3 <= max_2x1_plus_x3;

% Allocation requirement: x2 must be at least five more than twice x4
constraint x2 - 2 * x4 >= min_x2_minus_2x4;

% Total cost definition (linear expression over integer decision variables)
constraint total_cost =
  cost_x1 * x1 +
  cost_x2 * x2 +
  cost_x3 * x3 +
  cost_x4 * x4;

% Objective
solve minimize total_cost;