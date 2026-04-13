% Parameters
int: B = 10000;

set of int: I = 1..4;

array[I] of float: risk = [0.06, 0.05, 0.07, 0.08];
array[I] of float: ret  = [0.04, 0.02, 0.0,  0.0];

float: min_return_diff = 200.0;   % 0.04*x1 - 0.02*x2 >= 200
int: max_x3_minus_2x4  = 500;     % x3 - 2*x4 <= 500

% Bounds (not specified explicitly in the statement, so allow 0..B)
array[I] of int: lb = [0, 0, 0, 0];
array[I] of int: ub = [B, B, B, B];

% Variables
array[I] of var int: x;
var float: total_risk;

% Constraints
constraint forall(i in I) (x[i] >= lb[i]);
constraint forall(i in I) (x[i] <= ub[i]);

constraint sum(i in I)(x[i]) = B;

constraint ret[1]*int2float(x[1]) - ret[2]*int2float(x[2]) >= min_return_diff;

constraint x[3] - 2*x[4] <= max_x3_minus_2x4;

constraint total_risk = sum(i in I)(risk[i] * int2float(x[i]));

% Objective
solve minimize total_risk;