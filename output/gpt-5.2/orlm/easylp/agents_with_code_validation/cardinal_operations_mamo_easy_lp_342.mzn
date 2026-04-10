% Parameters
% Operating cost per vehicle on each route
int: c1 = 10;
int: c2 = 9;
int: c3 = 11;
int: c4 = 12;

% Constraint bounds (capacity / minimum coverage)
int: max_x1_x2 = 500;   % x1 + x2 <= 500
int: max_x3_x4 = 400;   % x3 + x4 <= 400
int: min_x1_x3 = 300;   % x1 + x3 >= 300
int: min_x2_x4 = 600;   % x2 + x4 >= 600


% Variables
% Number of vehicles allocated to each route (whole number, non-negative)
var 0..10000: x1;
var 0..10000: x2;
var 0..10000: x3;
var 0..10000: x4;

% Total operating cost (upper bound based on worst-case allocation bound)
var 0..(12 * 10000 * 4): total_cost;


% Constraints
%--- Capacity constraints (upper bounds) ---
constraint x1 + x2 <= max_x1_x2;   % Traffic/regulation limit on routes x1 and x2
constraint x3 + x4 <= max_x3_x4;   % Traffic/regulation limit on routes x3 and x4

%--- Minimum coverage constraints (lower bounds) ---
constraint x1 + x3 >= min_x1_x3;   % Ensure sufficient coverage via routes x1 and x3
constraint x2 + x4 >= min_x2_x4;   % Ensure sufficient coverage via routes x2 and x4

%--- Total operating cost definition ---
constraint total_cost = c1 * x1 + c2 * x2 + c3 * x3 + c4 * x4;


% Objective
solve minimize total_cost;