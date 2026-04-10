include "globals.mzn";

% Departments: X1, X2, X3, X4
% Workloads per employee in each department
array[1..4] of int: w = [30, 40, 50, 60];

% Decision variables: number of employees in each department (whole numbers)
% Bounds are not specified, so we use safe, finite upper bounds implied by constraints.
% From X2 + X3 <= 20 and X3 >= X4 + 5 with nonnegativity, all are naturally bounded by 0..20.
array[1..4] of var 0..20: x; % x[1]=X1, x[2]=X2, x[3]=X3, x[4]=X4

% Constraints
constraint x[1] + x[2] >= 10;          % X1 + X2 >= 10
constraint x[2] + x[3] <= 20;          % X2 + X3 <= 20
constraint x[3] >= x[4] + 5;           % X3 >= X4 + 5

% 0.5*X1 + 0.6*X2 - 0.7*X3 + 0.8*X4 <= 15
% Multiply by 10 to keep integrality:
constraint 5*x[1] + 6*x[2] - 7*x[3] + 8*x[4] <= 150;

% Objective: minimize total workload
var int: total_workload = sum(i in 1..4)(w[i] * x[i]);

solve minimize total_workload;

output [
  "X1=", show(x[1]), " X2=", show(x[2]), " X3=", show(x[3]), " X4=", show(x[4]), "\n",
  "Total workload=", show(total_workload), "\n"
];