% Parameters
int: n = 4;
set of int: P = 1..n;

array[P] of int: risk = [5, 7, 6, 8];

int: c12 = 5000;
int: c13 = 6000;
int: min_diff_24 = 1000;
int: max_diff_1_3x3 = 2000;

% Variables
array[P] of var 0..6000: x;

% Constraints
constraint 3*x[1] + 4*x[2] <= c12;
constraint 2*x[1] + 5*x[3] <= c13;
constraint x[2] - x[4] >= min_diff_24;
constraint x[1] - 3*x[3] <= max_diff_1_3x3;

% Objective
solve minimize sum(i in P)(risk[i] * x[i]);