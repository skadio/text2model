% Parameters
int: n = 4;
set of int: UNITS = 1..n;

array[UNITS] of int: cost = [300, 200, 500, 400];

int: c1_rhs = 1000;  % x1 + x2 <= 1000
int: c2_rhs = 800;   % 2*x1 + x3 >= 800
int: c3_rhs = 300;   % x2 - 0.5*x4 >= 300  ->  2*x2 - x4 >= 600
int: c4_rhs = 70;    % x2 - x3 - x1 <= 70

% Variables
array[UNITS] of var 0..10000: x;

% Constraints
constraint x[1] + x[2] <= c1_rhs;

constraint 2 * x[1] + x[3] >= c2_rhs;

constraint 2 * x[2] - x[4] >= 2 * c3_rhs;

constraint x[2] - x[3] - x[1] <= c4_rhs;

% Objective
var int: total_cost = sum(i in UNITS)(cost[i] * x[i]);
solve minimize total_cost;