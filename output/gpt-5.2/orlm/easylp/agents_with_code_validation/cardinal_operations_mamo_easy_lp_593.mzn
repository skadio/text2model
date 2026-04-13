% Parameters
% Unit costs for each route
int: cost_x1 = 10;
int: cost_x2 = 20;
int: cost_x3 = 30;
int: cost_x4 = 40;

% Combined capacity limits
int: cap_x1_x2 = 1000;          % Max x1 + x2
int: cap_x3_x4 = 2000;          % Max x3 + x4

% Minimum difference (demand/relative allocation) requirements
int: min_diff_x3_x1 = 500;      % x3 >= x1 + 500
int: min_diff_x4_x2 = 300;      % x4 >= x2 + 300

% Individual upper bounds
int: ub_x1 = 700;
int: ub_x2 = 800;
int: ub_x3 = 900;
int: ub_x4 = 1000;

% Variables
% Integer, nonnegative allocations for each route (bounded above)
var 0..ub_x1: x1;
var 0..ub_x2: x2;
var 0..ub_x3: x3;
var 0..ub_x4: x4;

% Total cost variable (bounded by maximum possible cost under UBs)
var 0..(cost_x1*ub_x1 + cost_x2*ub_x2 + cost_x3*ub_x3 + cost_x4*ub_x4): total_cost;

% Constraints
% --- Capacity constraints (combined allocations) ---
constraint x1 + x2 <= cap_x1_x2;
constraint x3 + x4 <= cap_x3_x4;

% --- Demand / difference constraints (relative allocations) ---
constraint x3 >= x1 + min_diff_x3_x1;
constraint x4 >= x2 + min_diff_x4_x2;

% --- Total cost definition ---
constraint total_cost = cost_x1 * x1 + cost_x2 * x2 + cost_x3 * x3 + cost_x4 * x4;

% Objective
solve minimize total_cost;