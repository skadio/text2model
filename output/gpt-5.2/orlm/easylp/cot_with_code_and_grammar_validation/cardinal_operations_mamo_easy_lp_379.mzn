% Parameters
int: n = 4;
set of int: DEPTS = 1..n;

array[DEPTS] of int: workload = [30, 40, 50, 60];

% Constraints:
% x1 + x2 >= 10
% x2 + x3 <= 20
% x3 >= x4 + 5
% 0.5*x1 + 0.6*x2 - 0.7*x3 + 0.8*x4 <= 15
% x1..x4 are whole numbers (implicitly by var int)
% Use scaled integers to avoid floating point: multiply by 10
array[DEPTS] of int: w_num10 = [5, 6, -7, 8];
int: rhs10 = 150;

% Variables
array[DEPTS] of var 0..1000: x; % x[1]=x1, x[2]=x2, x[3]=x3, x[4]=x4
var 0..(1000 * sum(workload)): total_workload;

% Constraints
constraint x[1] + x[2] >= 10;
constraint x[2] + x[3] <= 20;
constraint x[3] >= x[4] + 5;
constraint sum(d in DEPTS)(w_num10[d] * x[d]) <= rhs10;

constraint total_workload = sum(d in DEPTS)(workload[d] * x[d]);

% Objective
solve minimize total_workload;