% Parameters
% Cost coefficients for each department allocation (x1..x4)
array[1..4] of int: cost = [2, 3, 4, 5];

% Constraint constants
int: max_x1_x2 = 1000;      % x1 + x2 <= 1000
int: min_2x1_3x2 = 500;     % 2*x1 + 3*x2 >= 500
int: max_diff_x3_x1 = 200;  % x3 - x1 <= 200
int: min_x4_minus_x2 = 150; % x4 - x2 >= 150


% Variables
% Decision variables: integer allocations for each department
var 0..1000: x1;
var 0..1000: x2;
var 0..1200: x3;  % allow up to x1+200
var 0..1150: x4;  % allow up to x2+150

% Total operating cost (objective expression)
var int: total_cost;


% Constraints
% --- Budget limitation on departments 1 and 2 ---
constraint
  x1 + x2 <= max_x1_x2;

% --- Minimum service level requirement based on weighted allocations ---
constraint
  2 * x1 + 3 * x2 >= min_2x1_3x2;

% --- Balance constraint: department 3 not too far above department 1 ---
constraint
  x3 - x1 <= max_diff_x3_x1;

% --- Strategic/demand constraint: department 4 sufficiently above department 2 ---
constraint
  x4 - x2 >= min_x4_minus_x2;

% Define total cost
constraint
  total_cost = cost[1]*x1 + cost[2]*x2 + cost[3]*x3 + cost[4]*x4;


% Objective
solve minimize total_cost;

output [
  "x1=", show(x1), "\n",
  "x2=", show(x2), "\n",
  "x3=", show(x3), "\n",
  "x4=", show(x4), "\n",
  "min_total_cost=", show(total_cost), "\n"
];