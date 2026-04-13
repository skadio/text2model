% Parameters
% Maximum combined unit counts due to logistical constraints
int: max_x1_x2 = 200;
int: max_x3_x4 = 150;

% Minimum required combined strengths (strategic objectives)
int: min_strength_12 = 1000;
int: min_strength_34 = 750;

% Strength coefficients
int: strength_x1 = 5;
int: strength_x2 = 10;
float: strength_x3 = 7.5; % used conceptually; constraint is scaled to avoid floats
int: strength_x4 = 5;

% Cost per unit (in dollars)
int: cost_x1 = 5000;
int: cost_x2 = 7000;
int: cost_x3 = 10000;
int: cost_x4 = 3000;


% Variables
% Integer decision variables: number of units of each type
var 0..max_x1_x2: x1;  % Units of type X1
var 0..max_x1_x2: x2;  % Units of type X2
var 0..max_x3_x4: x3;  % Units of type X3
var 0..max_x3_x4: x4;  % Units of type X4

% Total cost (in dollars)
var 0..(max_x1_x2 * max(cost_x1, cost_x2) + max_x3_x4 * max(cost_x3, cost_x4)): total_cost;


% Constraints
% --- Logistical capacity constraints (unit count limits) ---
constraint x1 + x2 <= max_x1_x2;  % Combined units of X1 and X2 cannot exceed capacity
constraint x3 + x4 <= max_x3_x4;  % Combined units of X3 and X4 cannot exceed capacity

% --- Strategic strength constraints (minimum required strength) ---
constraint strength_x1 * x1 + strength_x2 * x2 >= min_strength_12;

% Avoid float arithmetic by scaling:
% 7.5*x3 + 5*x4 >= 750  <=>  15*x3 + 10*x4 >= 1500
constraint 15 * x3 + (2 * strength_x4) * x4 >= 2 * min_strength_34;

% --- Total cost definition constraint ---
constraint total_cost = cost_x1 * x1 + cost_x2 * x2 + cost_x3 * x3 + cost_x4 * x4;


% Objective
solve minimize total_cost;