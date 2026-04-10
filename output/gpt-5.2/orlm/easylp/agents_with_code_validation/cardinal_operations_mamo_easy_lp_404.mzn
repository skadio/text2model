% Parameters
% Unit transportation costs
int: cost_x1 = 4;
int: cost_x2 = 3;
int: cost_x3 = 5;
int: cost_x4 = 7;

% Capacity / demand limits
int: cap_12 = 1000;     % x1 + x2 <= 1000
int: cap_34 = 800;      % x3 + x4 <= 800
int: min_13 = 500;      % x1 + x3 >= 500
int: min_24 = 600;      % x2 + x4 >= 600

% Bounds on each cargo type
int: x1_lb = 0;  int: x1_ub = 700;
int: x2_lb = 0;  int: x2_ub = 600;
int: x3_lb = 0;  int: x3_ub = 400;
int: x4_lb = 0;  int: x4_ub = 500;

% Variables
var x1_lb..x1_ub: x1;   % units of cargo type 1
var x2_lb..x2_ub: x2;   % units of cargo type 2
var x3_lb..x3_ub: x3;   % units of cargo type 3
var x4_lb..x4_ub: x4;   % units of cargo type 4

% Total cost (upper bound derived from max bounds)
var 0..(cost_x1*x1_ub + cost_x2*x2_ub + cost_x3*x3_ub + cost_x4*x4_ub): total_cost;

% Constraints
% Capacity constraints (ship space limits)
constraint x1 + x2 <= cap_12;
constraint x3 + x4 <= cap_34;

% Minimum demand constraints (must ship at least these totals)
constraint x1 + x3 >= min_13;
constraint x2 + x4 >= min_24;

% Total cost definition (link total_cost to decision variables)
constraint total_cost = cost_x1 * x1 + cost_x2 * x2 + cost_x3 * x3 + cost_x4 * x4;

% Objective
solve minimize total_cost;