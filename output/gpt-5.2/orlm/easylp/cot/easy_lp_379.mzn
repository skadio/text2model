% Parameters (with values embedded)
int: n = 4;
set of int: DEPTS = 1..n;

int: X1 = 1;
int: X2 = 2;
int: X3 = 3;
int: X4 = 4;

array[DEPTS] of int: workload = [30, 40, 50, 60];

% Variables
array[DEPTS] of var 0..1000: emp;   % integer employees per department (nonnegative, bounded)

% Constraints
constraint emp[X1] + emp[X2] >= 10;
constraint emp[X2] + emp[X3] <= 20;
constraint emp[X3] >= emp[X4] + 5;

% 0.5*x1 + 0.6*x2 - 0.7*x3 + 0.8*x4 <= 15
% Multiply by 10 to keep it integer: 5*x1 + 6*x2 - 7*x3 + 8*x4 <= 150
constraint 5*emp[X1] + 6*emp[X2] - 7*emp[X3] + 8*emp[X4] <= 150;

% Objective
var int: total_workload = sum(d in DEPTS)(workload[d] * emp[d]);

solve minimize total_workload;