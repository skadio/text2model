% Parameters
% Employee cost per project (in dollars)
int: cost_x1 = 50;
int: cost_x2 = 80;
int: cost_x3 = 30;
int: cost_x4 = 70;

% Capacity constraints
int: cap_x1_x2 = 40;   % x1 + x2 <= 40
int: cap_x3_x4 = 60;   % x3 + x4 <= 60

% Minimum staffing constraints
int: min_x1_x3 = 20;   % x1 + x3 >= 20
int: min_x2_x4 = 30;   % x2 + x4 >= 30

% Variable bounds
int: x1_lb = 0;  int: x1_ub = 25;
int: x2_lb = 0;  int: x2_ub = 25;
int: x3_lb = 0;  int: x3_ub = 35;
int: x4_lb = 0;  int: x4_ub = 35;

% Variables
var x1_lb..x1_ub: x1;  % employees allocated to project x1
var x2_lb..x2_ub: x2;  % employees allocated to project x2
var x3_lb..x3_ub: x3;  % employees allocated to project x3
var x4_lb..x4_ub: x4;  % employees allocated to project x4

% Total cost variable (bounded above by worst-case within variable upper bounds)
var 0..(cost_x1*x1_ub + cost_x2*x2_ub + cost_x3*x3_ub + cost_x4*x4_ub): total_cost;

% Constraints
% --- Capacity constraints (office space limits) ---
constraint x1 + x2 <= cap_x1_x2;
constraint x3 + x4 <= cap_x3_x4;

% --- Minimum staffing constraints (manpower requirements) ---
constraint x1 + x3 >= min_x1_x3;
constraint x2 + x4 >= min_x2_x4;

% --- Total cost definition (link total_cost to allocations) ---
constraint total_cost = cost_x1 * x1 + cost_x2 * x2 + cost_x3 * x3 + cost_x4 * x4;

% Objective
solve minimize total_cost;