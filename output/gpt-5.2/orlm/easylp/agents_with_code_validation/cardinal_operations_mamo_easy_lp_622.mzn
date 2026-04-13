% Parameters
% Unit costs for each activity
int: cost_x1 = 2;
int: cost_x2 = 3;
int: cost_x3 = 4;
int: cost_x4 = 5;

% Combined capacity limits
int: cap_x1x2 = 1000;      % x1 + x2 <= 1000
int: cap_x3x4 = 800;       % x3 + x4 <= 800

% Individual upper bounds (all variables are nonnegative)
int: ub_x1 = 500;
int: ub_x2 = 600;
int: ub_x3 = 400;
int: ub_x4 = 300;

% Linear requirement bounds (given in original fractional form)
int: min_expr1 = 50;       % 0.5*x1 - 0.6*x2 >= 50
int: max_expr2 = 70;       % 0.7*x3 - x4 <= 70


% Variables
% Integer allocations for each activity within given bounds
var 0..ub_x1: x1;
var 0..ub_x2: x2;
var 0..ub_x3: x3;
var 0..ub_x4: x4;

% Total cost (linear objective)
var int: total_cost;


% Constraints
% --- Capacity constraints (combined allocation limits) ---
constraint x1 + x2 <= cap_x1x2;
constraint x3 + x4 <= cap_x3x4;

% --- Linear requirement constraints (scaled to avoid fractions) ---
% 0.5*x1 - 0.6*x2 >= min_expr1  ==>  5*x1 - 6*x2 >= 10*min_expr1
constraint 5 * x1 - 6 * x2 >= 10 * min_expr1;

% 0.7*x3 - x4 <= max_expr2  ==>  7*x3 - 10*x4 <= 10*max_expr2
constraint 7 * x3 - 10 * x4 <= 10 * max_expr2;

% --- Total cost definition ---
constraint total_cost = cost_x1 * x1 + cost_x2 * x2 + cost_x3 * x3 + cost_x4 * x4;


% Objective
solve minimize total_cost;