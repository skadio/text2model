% Parameters
% Costs per vehicle on each route (embedded as per instructions)
int: cost_x1 = 2;
int: cost_x2 = 3;
int: cost_x3 = 4;
int: cost_x4 = 5;

% Capacity / requirement limits (embedded as per instructions)
int: max_x1_x2 = 100;   % x1 + x2 <= 100
int: max_x3_x4 = 200;   % x3 + x4 <= 200
int: min_x1_x3 = 50;    % x1 + x3 >= 50
int: min_x2_x4 = 150;   % x2 + x4 >= 150


% Variables
% Number of vehicles assigned to each route (must be whole numbers, non-negative)
var 0..max_x1_x2: x1;   % safe upper bound since x1 + x2 <= max_x1_x2
var 0..max_x1_x2: x2;   % safe upper bound since x1 + x2 <= max_x1_x2
var 0..max_x3_x4: x3;   % safe upper bound since x3 + x4 <= max_x3_x4
var 0..max_x3_x4: x4;   % safe upper bound since x3 + x4 <= max_x3_x4

% Total cost (upper bound from variable bounds)
var 0..(cost_x1*max_x1_x2 + cost_x2*max_x1_x2 + cost_x3*max_x3_x4 + cost_x4*max_x3_x4): total_cost;


% Constraints
% Route pair capacity constraints
constraint x1 + x2 <= max_x1_x2;
constraint x3 + x4 <= max_x3_x4;

% Minimum service/allocation requirements
constraint x1 + x3 >= min_x1_x3;
constraint x2 + x4 >= min_x2_x4;

% Total cost definition
constraint total_cost = cost_x1 * x1 + cost_x2 * x2 + cost_x3 * x3 + cost_x4 * x4;


% Objective
solve minimize total_cost;

output [
  "x1=", show(x1), " x2=", show(x2), " x3=", show(x3), " x4=", show(x4), "\n",
  "total_cost=", show(total_cost), "\n"
];