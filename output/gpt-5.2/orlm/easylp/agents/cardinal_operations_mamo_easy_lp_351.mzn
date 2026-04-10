% Parameters
% Cost per unit of allocation for each department
int: cost_x1 = 100; % general medicine
int: cost_x2 = 50;  % surgery
int: cost_x3 = 30;  % diagnostics
int: cost_x4 = 200; % research

% Minimum combined allocation requirements
int: min_x1_x2 = 10; % x1 + x2 >= 10
int: min_x3_x4 = 20; % x3 + x4 >= 20

% Bounds on allocations (assume non-negative)
int: lb_x1 = 0;
int: lb_x2 = 0;
int: lb_x3 = 0;
int: lb_x4 = 0;

% Safe upper bounds (large enough for feasibility)
int: ub_x1 = 1000;
int: ub_x2 = 1000;
int: ub_x3 = 1000;
int: ub_x4 = 1000;


% Variables
var lb_x1..ub_x1: x1; % integer allocation to general medicine
var lb_x2..ub_x2: x2; % integer allocation to surgery
var lb_x3..ub_x3: x3; % integer allocation to diagnostics
var lb_x4..ub_x4: x4; % integer allocation to research

var int: total_cost;  % total cost to minimize


% Constraints
% Total cost definition (linear expression of allocations and unit costs)
constraint total_cost =
  cost_x1 * x1 + cost_x2 * x2 + cost_x3 * x3 + cost_x4 * x4;

% Minimum combined allocation for general medicine and surgery
constraint x1 + x2 >= min_x1_x2;

% Minimum combined allocation for diagnostics and research
constraint x3 + x4 >= min_x3_x4;

% Funding balance between general medicine and surgery: 5*x1 - 2*x2 <= 0
constraint 5 * x1 - 2 * x2 <= 0;

% Priority on diagnostic services: 3*x3 - x4 >= 0
constraint 3 * x3 - x4 >= 0;


% Objective
solve minimize total_cost;