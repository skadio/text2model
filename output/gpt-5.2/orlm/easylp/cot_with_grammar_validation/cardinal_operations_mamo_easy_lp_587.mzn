% Parameters
int: N = 4;
set of int: P = 1..N;

array[P] of int: cost = [60, 50, 70, 80];

int: max_x1 = 400;
int: max_x2 = 350;
int: max_x3 = 250;
int: max_x4 = 150;

int: cap_12 = 500;
int: cap_34 = 300;
int: min_13 = 200;
int: min_diff = 100;

% Variables
array[P] of var int: x;

var int: total_cost;

% Constraints
constraint x[1] >= 0 /\ x[1] <= max_x1;
constraint x[2] >= 0 /\ x[2] <= max_x2;
constraint x[3] >= 0 /\ x[3] <= max_x3;
constraint x[4] >= 0 /\ x[4] <= max_x4;

constraint x[1] + x[2] <= cap_12;
constraint x[3] + x[4] <= cap_34;

constraint x[1] + x[3] >= min_13;

% Ensure integrality of (x2 - x4/2) constraint without fractions:
% x2 - x4/2 >= 100  <=>  2*x2 - x4 >= 200
constraint 2 * x[2] - x[4] >= 2 * min_diff;

constraint total_cost = sum(i in P)(cost[i] * x[i]);

% Objective
solve minimize total_cost;