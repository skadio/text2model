% Parameters (embedded data)
int: w1 = 30;  % Department X1 workload
int: w2 = 40;  % Department X2 workload
int: w3 = 50;  % Department X3 workload
int: w4 = 60;  % Department X4 workload

float: c1 = 0.5;
float: c2 = 0.6;
float: c3 = -0.7;
float: c4 = 0.8;

int: min_x1_x2 = 10;        % x1 + x2 >= 10
int: max_x2_x3 = 20;        % x2 + x3 <= 20
int: delta_x3_x4 = 5;       % x3 >= x4 + 5
float: max_weighted = 15.0; % 0.5*x1 + 0.6*x2 - 0.7*x3 + 0.8*x4 <= 15

int: lb = 0;
int: ub = 1000;

% Decision variables (integer employee counts)
var lb..ub: x1;
var lb..ub: x2;
var lb..ub: x3;
var lb..ub: x4;

% Total workload (no intmax in MiniZinc; give a safe upper bound)
var 0..(w1*ub + w2*ub + w3*ub + w4*ub): total_workload;

% Constraints
constraint total_workload = w1*x1 + w2*x2 + w3*x3 + w4*x4;

constraint x1 + x2 >= min_x1_x2;
constraint x2 + x3 <= max_x2_x3;
constraint x3 >= x4 + delta_x3_x4;

constraint
  c1 * int2float(x1) +
  c2 * int2float(x2) +
  c3 * int2float(x3) +
  c4 * int2float(x4)
  <= max_weighted;

% Objective
solve minimize total_workload;