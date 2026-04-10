% Parameters
%--------------------------
% Budget limit (total investment cannot exceed this)
int: budget = 100;

% Demand constraint parameters: a1*x1 + a2*x2 >= demand_min
int: a1 = 2;
int: a2 = 3;
int: demand_min = 50;

% Risk constraint parameters: r1*x1 - r3*x3 <= risk_max
int: r1 = 4;
int: r3 = 5;
int: risk_max = 30;

% Unit costs for each supplier
int: c1 = 5;
int: c2 = 4;
int: c3 = 3;

% Maximum allocation limits for each supplier
int: max_x1 = budget;
int: max_x2 = budget;
int: max_x3 = budget;


% Variables
%--------------------------
% Integer investments in each supplier (non-negative, bounded)
var 0..max_x1: x1;
var 0..max_x2: x2;
var 0..max_x3: x3;

% Total cost (bounded for linear safety; upper bound uses max allocations)
var 0..(c1*max_x1 + c2*max_x2 + c3*max_x3): total_cost;


% Constraints
%--------------------------
% Total cost definition
constraint total_cost = c1 * x1 + c2 * x2 + c3 * x3;

% Budget constraint
constraint x1 + x2 + x3 <= budget;

% Demand satisfaction constraint
constraint a1 * x1 + a2 * x2 >= demand_min;

% Risk management constraint
constraint r1 * x1 - r3 * x3 <= risk_max;


% Objective
solve minimize total_cost;

% Optional output
output [
  "x1=", show(x1), " x2=", show(x2), " x3=", show(x3), "\n",
  "total_cost=", show(total_cost), "\n"
];