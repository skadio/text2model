% Parameters
int: BUDGET = 10000;

set of int: I = 1..4;

array[I] of float: risk = [0.06, 0.05, 0.07, 0.08];
array[I] of float: ret  = [0.04, 0.02, 0.00, 0.00];

% Specific constraint parameters
float: min_ret_diff = 200.0;   % 0.04*x1 - 0.02*x2 >= 200
int: max_diff_x3_2x4 = 500;    % |x3 - 2*x4| <= 500

% Bounds on allocations (whole dollars)
array[I] of int: lb = [0, 0, 0, 0];
array[I] of int: ub = [BUDGET, BUDGET, BUDGET, BUDGET];

% Variables
array[I] of var int: x;

var float: total_risk;

% Constraints
constraint forall(i in I) (lb[i] <= x[i] /\ x[i] <= ub[i]);

constraint sum(i in I)(x[i]) = BUDGET;

constraint ret[1]*int2float(x[1]) - ret[2]*int2float(x[2]) >= min_ret_diff;

constraint abs(x[3] - 2*x[4]) <= max_diff_x3_2x4;

constraint total_risk = sum(i in I)(risk[i] * int2float(x[i]));

% Objective
solve minimize total_risk;