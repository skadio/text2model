% Parameters
% Operating cost per vehicle on each route (x1..x4)
array[1..4] of int: cost = [10, 9, 11, 12];

% Constraint limits
int: max_x1_x2 = 500;   % x1 + x2 <= 500
int: max_x3_x4 = 400;   % x3 + x4 <= 400
int: min_x1_x3 = 300;   % x1 + x3 >= 300
int: min_x2_x4 = 600;   % x2 + x4 >= 600

% Vehicle allocation lower bound (nonnegative integer allocations)
int: lb_vehicles = 0;

% Variables
var int: x1; % vehicles on route 1
var int: x2; % vehicles on route 2
var int: x3; % vehicles on route 3
var int: x4; % vehicles on route 4

var int: total_cost; % total operating cost

% Constraints
% --- Nonnegativity / lower bounds on vehicle allocations ---
constraint x1 >= lb_vehicles;
constraint x2 >= lb_vehicles;
constraint x3 >= lb_vehicles;
constraint x4 >= lb_vehicles;

% --- Route capacity / regulation limits (upper bounds on combined routes) ---
constraint x1 + x2 <= max_x1_x2;   % x1 + x2 cannot exceed 500
constraint x3 + x4 <= max_x3_x4;   % x3 + x4 cannot exceed 400

% --- Coverage / demand requirements (lower bounds on combined routes) ---
constraint x1 + x3 >= min_x1_x3;   % at least 300 between x1 and x3
constraint x2 + x4 >= min_x2_x4;   % at least 600 between x2 and x4

% --- Total operating cost definition ---
constraint total_cost = cost[1]*x1 + cost[2]*x2 + cost[3]*x3 + cost[4]*x4;

% Objective
solve minimize total_cost;

output [
  "x1=", show(x1), "\n",
  "x2=", show(x2), "\n",
  "x3=", show(x3), "\n",
  "x4=", show(x4), "\n",
  "total_cost=", show(total_cost), "\n"
];