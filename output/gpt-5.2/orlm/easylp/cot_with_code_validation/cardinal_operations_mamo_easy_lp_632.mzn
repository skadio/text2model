% Parameters
int: n = 4;
set of int: SESS = 1..n;

array[SESS] of int: fatigue = [1000, 1500, 2000, 2500];

int: max_x1_x2 = 20;
int: max_x3_x4 = 15;
int: min_x1_x3 = 10;
int: min_x2_x4 = 8;

% No additional per-session bounds were numerically specified; assume non-negative integers.
int: ub_default = 1000;

% Variables
array[SESS] of var 0..ub_default: x;

% Constraints
constraint x[1] + x[2] <= max_x1_x2;
constraint x[3] + x[4] <= max_x3_x4;

constraint x[1] + x[3] >= min_x1_x3;
constraint x[2] + x[4] >= min_x2_x4;

% Objective
var int: total_fatigue = sum(i in SESS)(fatigue[i] * x[i]);
solve minimize total_fatigue;