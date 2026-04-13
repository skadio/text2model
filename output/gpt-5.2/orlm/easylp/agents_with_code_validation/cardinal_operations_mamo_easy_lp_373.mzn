% Parameters
% Unit costs for each warehouse
int: cost_x1 = 10;
int: cost_x2 = 15;
int: cost_x3 = 20;
int: cost_x4 = 25;

% Capacity limits on combined allocations
int: cap_x1x2 = 500;   % x1 + x2 <= 500
int: cap_x3x4 = 400;   % x3 + x4 <= 400

% Minimum demand requirements
int: min_x1x3 = 350;   % x1 + x3 >= 350
int: min_x2x4 = 300;   % x2 + x4 >= 300


% Variables
% Integer allocations to each warehouse (non-negative)
var 0..cap_x1x2: x1;   % bounded by combined cap of (x1,x2)
var 0..cap_x1x2: x2;   % bounded by combined cap of (x1,x2)
var 0..cap_x3x4: x3;   % bounded by combined cap of (x3,x4)
var 0..cap_x3x4: x4;   % bounded by combined cap of (x3,x4)

% Total cost (for reporting)
var int: total_cost = cost_x1 * x1 + cost_x2 * x2 + cost_x3 * x3 + cost_x4 * x4;


% Constraints
% Combined capacity constraints (pairwise limits)
constraint x1 + x2 <= cap_x1x2;
constraint x3 + x4 <= cap_x3x4;

% Minimum demand / coverage constraints (cross-pair requirements)
constraint x1 + x3 >= min_x1x3;
constraint x2 + x4 >= min_x2x4;


% Objective
solve minimize total_cost;

output [
  "x1=", show(x1), "\n",
  "x2=", show(x2), "\n",
  "x3=", show(x3), "\n",
  "x4=", show(x4), "\n",
  "minimum_total_cost=", show(total_cost), "\n"
];