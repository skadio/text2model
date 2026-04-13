% Parameters
% Cost per employee assigned to each project
int: cost_x1 = 50;
int: cost_x2 = 80;
int: cost_x3 = 30;
int: cost_x4 = 70;

% Capacity constraints (upper bounds on combined staffing)
int: cap_12 = 40;   % x1 + x2 <= 40
int: cap_34 = 60;   % x3 + x4 <= 60

% Minimum staffing requirements (lower bounds on combined staffing)
int: min_13 = 20;   % x1 + x3 >= 20
int: min_24 = 30;   % x2 + x4 >= 30

% Individual variable bounds
int: x1_lb = 0;  int: x1_ub = 25;
int: x2_lb = 0;  int: x2_ub = 25;
int: x3_lb = 0;  int: x3_ub = 35;
int: x4_lb = 0;  int: x4_ub = 35;

% Variables
% Integer number of employees assigned to each project
var x1_lb..x1_ub: x1;
var x2_lb..x2_ub: x2;
var x3_lb..x3_ub: x3;
var x4_lb..x4_ub: x4;

% Total cost (upper bound derived from variable upper bounds)
var 0..(cost_x1*x1_ub + cost_x2*x2_ub + cost_x3*x3_ub + cost_x4*x4_ub): total_cost;

% Constraints
% Capacity constraints: limit combined staffing due to space constraints
constraint x1 + x2 <= cap_12;
constraint x3 + x4 <= cap_34;

% Minimum staffing constraints: ensure sufficient manpower across paired projects
constraint x1 + x3 >= min_13;
constraint x2 + x4 >= min_24;

% Total cost definition: linear cost from staffing allocation
constraint total_cost = cost_x1 * x1 + cost_x2 * x2 + cost_x3 * x3 + cost_x4 * x4;

% Objective
solve minimize total_cost;