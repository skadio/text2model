% Employee allocation across departments X1..X4
% Minimize total workload: 30, 40, 50, 60 per employee in X1..X4

int: n = 4;
set of int: D = 1..n;

array[D] of int: workload = [30, 40, 50, 60];

% Bounds (not specified in the statement). Use safe finite bounds for integrality search.
int: UB = 100;

array[D] of var 0..UB: x; % x[1]=X1, x[2]=X2, x[3]=X3, x[4]=X4

% Constraints
constraint x[1] + x[2] >= 10;
constraint x[2] + x[3] <= 20;
constraint x[3] >= x[4] + 5;

% 0.5*x1 + 0.6*x2 - 0.7*x3 + 0.8*x4 <= 15
% Multiply by 10 to avoid floats: 5*x1 + 6*x2 - 7*x3 + 8*x4 <= 150
constraint 5*x[1] + 6*x[2] - 7*x[3] + 8*x[4] <= 150;

% Objective: minimize total workload
var int: total_workload = sum(d in D)(workload[d] * x[d]);
solve minimize total_workload;

output [
  "X1=", show(x[1]), " X2=", show(x[2]), " X3=", show(x[3]), " X4=", show(x[4]), "\n",
  "Minimum total workload=", show(total_workload), "\n"
];