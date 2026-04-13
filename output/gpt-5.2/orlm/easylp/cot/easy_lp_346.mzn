% Parameters (with values embedded)
int: n = 4;
set of int: P = 1..n;

array[P] of int: risk = [5, 7, 6, 8];

% NOTE: The problem statement mentions "specific bounds on fund allocation"
% but does not provide numeric bounds. We therefore model investments as
% non-negative whole dollars (integers) with implied lower bound 0.
int: maxInv = 100000; % safe artificial upper bound to keep variables bounded

% Variables
array[P] of var 0..maxInv: x; % x[1]=x1, x[2]=x2, x[3]=x3, x[4]=x4

% Constraints
constraint 3*x[1] + 4*x[2] <= 5000;
constraint 2*x[1] + 5*x[3] <= 6000;
constraint x[2] - x[4] >= 1000;
constraint x[1] - 3*x[3] <= 2000;

% Objective
var int: total_risk = sum(i in P)(risk[i] * x[i]);
solve minimize total_risk;