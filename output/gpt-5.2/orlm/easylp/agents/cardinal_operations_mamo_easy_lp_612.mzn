% Parameters
% Cost per unit for each crop
int: cost_x1 = 50;
int: cost_x2 = 30;
int: cost_x3 = 20;
int: cost_x4 = 10;

% Constraint constants
int: land_cap_x1_x2 = 1000;      % x1 + x2 <= 1000
int: min_diversity = 500;        % 2*x3 + 3*x4 >= 500
int: max_diff_x1_x4 = 200;       % |x1 - x4| <= 200

% Variables
% Resource allocations (whole numbers, non-negative)
var 0..1000: x1;                 % crop 1 allocation
var 0..1000: x2;                 % crop 2 allocation
var 0..1000: x3;                 % crop 3 allocation
var 0..1000: x4;                 % crop 4 allocation

% Total cost (bounded for linear expressions)
var 0..(cost_x1*1000 + cost_x2*1000 + cost_x3*1000 + cost_x4*1000): total_cost;

% Constraints
% Land capacity: combined allocation for crops x1 and x2 cannot exceed available land
constraint
  x1 + x2 <= land_cap_x1_x2;

% Diversity / soil health requirement: weighted combination of x3 and x4 must meet minimum threshold
constraint
  2 * x3 + 3 * x4 >= min_diversity;

% Balance between cash and food crops: keep x1 and x4 within a maximum absolute difference
constraint
  abs(x1 - x4) <= max_diff_x1_x4;

% Climate/soil condition: "half of x3 >= x2" rewritten to avoid fractions (type-safe integer form)
constraint
  x3 >= 2 * x2;

% Total cost definition (linear expression tying total_cost to allocations)
constraint
  total_cost = cost_x1 * x1 + cost_x2 * x2 + cost_x3 * x3 + cost_x4 * x4;

% Objective
solve minimize total_cost;

output [
  "x1=", show(x1), "\n",
  "x2=", show(x2), "\n",
  "x3=", show(x3), "\n",
  "x4=", show(x4), "\n",
  "total_cost=", show(total_cost), "\n"
];