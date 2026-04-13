% Parameters (with values embedded)
int: n = 4;
set of int: R = 1..n;

array[R] of float: cost = [0.5, 0.6, 0.8, 1.2];

int: cap12 = 300;
int: cap34 = 500;

int: rhs3 = 100;  % 0.7*x2 - x1 - x3 + 0.9*x4 >= 100
int: rhs4 = 200;  % (x3 - 0.8*x4) - (x1 + x2) <= 200

% Variables
array[R] of var 0..500: x;  % allocations for X1..X4 (integer, nonnegative)

% Constraints
constraint x[1] + x[2] <= cap12;
constraint x[3] + x[4] <= cap34;

% Convert fractional coefficients to integers by multiplying by 10:
% 0.7*x2 - x1 - x3 + 0.9*x4 >= 100  <=>  7*x2 - 10*x1 - 10*x3 + 9*x4 >= 1000
constraint 7*x[2] - 10*x[1] - 10*x[3] + 9*x[4] >= 1000;

% (x3 - 0.8*x4) - (x1 + x2) <= 200  <=>  10*x3 - 8*x4 - 10*x1 - 10*x2 <= 2000
constraint 10*x[3] - 8*x[4] - 10*x[1] - 10*x[2] <= 2000;

% Objective
var float: total_cost = sum(i in R)(cost[i] * int2float(x[i]));
solve minimize total_cost;

output [
  "x1=", show(x[1]), " x2=", show(x[2]), " x3=", show(x[3]), " x4=", show(x[4]), "\n",
  "total_cost=", show(total_cost), "\n",
  "total_cost_1dp=", show(round(total_cost * 10.0) / 10.0), "\n"
];