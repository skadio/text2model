% Parameters
int: Budget = 10000;
int: N = 4;

array[1..N] of float: risk = [0.06, 0.05, 0.07, 0.08];
array[1..N] of float: ret  = [0.04, 0.02, 0.0, 0.0];

% Allocation bounds (not specified numerically in the description; using nonnegativity)
array[1..N] of int: lb = [0, 0, 0, 0];
array[1..N] of int: ub = [Budget, Budget, Budget, Budget];

% Variables
array[1..N] of var int: x;
var float: total_risk;

% Constraints
constraint forall(i in 1..N) (lb[i] <= x[i] /\ x[i] <= ub[i]);

constraint sum(i in 1..N)(x[i]) = Budget;

constraint ret[1]*int2float(x[1]) - ret[2]*int2float(x[2]) >= 200.0;

constraint abs(x[3] - 2*x[4]) <= 500;

constraint total_risk = sum(i in 1..N)(risk[i] * int2float(x[i]));

% Objective
solve minimize total_risk;