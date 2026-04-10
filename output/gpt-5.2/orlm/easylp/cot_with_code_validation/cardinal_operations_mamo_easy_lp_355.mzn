% Parameters
int: n = 4;
set of int: DEPT = 1..n;

array[DEPT] of int: cost = [5, 3, 2, 7];

% Constraints data (all embedded)
int: c1_rhs = 150; % 2*x1 + 3*x2 <= 150
int: c2_rhs = 30;  % x1 + x4 >= 30
int: c3_rhs = 10;  % x3 - x4 <= 10  (as stated)
int: c4_rhs = 80;  % 4*x1 + 5*x2 + x3 >= 80

% Variables
array[DEPT] of var 0..150: x; % resource allocations (bounded nonnegative; 150 is a safe explicit upper bound)

var int: total_cost;

% Constraints
constraint 2*x[1] + 3*x[2] <= c1_rhs;
constraint x[1] + x[4] >= c2_rhs;
constraint x[3] - x[4] <= c3_rhs;
constraint 4*x[1] + 5*x[2] + x[3] >= c4_rhs;

constraint total_cost = sum(i in DEPT)(cost[i] * x[i]);

% Objective
solve minimize total_cost;