% Parameters
% Unit costs (float because some costs are fractional)
float: cost_x1 = 1.5;          % unit cost for allocation x1
float: cost_x2 = 2.0;          % unit cost for allocation x2
float: cost_x3 = 3.0;          % unit cost for allocation x3
float: cost_x4 = 4.0;          % unit cost for allocation x4

% Capacity limits
int: cap12 = 1000;             % upper bound on x1 + x2
int: cap34 = 1200;             % upper bound on x3 + x4

% Strategic constraint coefficients and minimum differences
float: a1 = 0.7;               % coefficient for x1
float: a2 = 0.8;               % coefficient for x2
int: min_diff12 = 200;         % lower bound on (0.7*x1 - 0.8*x2)
int: min_diff43 = 300;         % lower bound on (x4 - x3)

% Variables
% Integer allocations (bounded by relevant caps for safety)
var 0..cap12: x1;              % allocation to area x1
var 0..cap12: x2;              % allocation to area x2
var 0..cap34: x3;              % allocation to area x3
var 0..cap34: x4;              % allocation to area x4

% Total cost (float due to fractional unit costs)
var float: total_cost;

% Constraints
% Capacity constraints
constraint x1 + x2 <= cap12;
constraint x3 + x4 <= cap34;

% Strategic balance constraint in float domain (avoid int/float coercion issues)
constraint a1 * int2float(x1) - a2 * int2float(x2) >= int2float(min_diff12);

% Emphasis constraint: x4 exceeds x3 by at least 300
constraint x4 - x3 >= min_diff43;

% Define total cost
constraint total_cost =
    cost_x1 * int2float(x1) +
    cost_x2 * int2float(x2) +
    cost_x3 * int2float(x3) +
    cost_x4 * int2float(x4);

% Objective
solve minimize total_cost;

output [
  "x1=", show(x1), " x2=", show(x2), " x3=", show(x3), " x4=", show(x4), "\n",
  "total_cost=", show(total_cost), "\n",
  "floor(total_cost)=", show(fix(total_cost)), "\n"
];