% Parameters
int: n = 4;
set of int: P = 1..n;

array[P] of int: risk = [5, 7, 6, 8];

int: C1_rhs = 5000;
int: C2_rhs = 6000;
int: C3_diff = 1000;
int: C4_rhs = 2000;

array[P] of int: lb = [0, 0, 0, 0];
array[P] of int: ub = [1000000, 1000000, 1000000, 1000000];

% Variables
array[P] of var int: x;
var int: total_risk;

% Constraints
constraint forall(i in P) (x[i] >= lb[i]);
constraint forall(i in P) (x[i] <= ub[i]);

% 3*x1 + 4*x2 <= 5000
constraint 3 * x[1] + 4 * x[2] <= C1_rhs;

% 2*x1 + 5*x3 <= 6000
constraint 2 * x[1] + 5 * x[3] <= C2_rhs;

% x2 - x4 >= 1000
constraint x[2] - x[4] >= C3_diff;

% x1 - 3*x3 <= 2000
constraint x[1] - 3 * x[3] <= C4_rhs;

% Objective
constraint total_risk = sum(i in P)(risk[i] * x[i]);
solve minimize total_risk;