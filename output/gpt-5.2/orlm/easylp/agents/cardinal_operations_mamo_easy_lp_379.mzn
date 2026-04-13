% Parameters
int: nDepts = 4;                                 % number of departments
set of int: DEPTS = 1..nDepts;                   % department index set

array[DEPTS] of int: workload = [30, 40, 50, 60]; % workload units per employee in X1..X4

int: min_X1_X2 = 10;                             % X1 + X2 >= 10
int: max_X2_X3 = 20;                             % X2 + X3 <= 20
int: min_diff_X3_X4 = 5;                         % X3 >= X4 + 5

float: w1 = 0.5;                                 % weight for X1
float: w2 = 0.6;                                 % weight for X2
float: w3 = -0.7;                                % weight for X3
float: w4 = 0.8;                                 % weight for X4
float: weighted_max = 15.0;                      % weighted combination upper bound

% Department indices for readability
int: X1 = 1;
int: X2 = 2;
int: X3 = 3;
int: X4 = 4;

% Variables
array[DEPTS] of var 0..1000: employees;          % employees assigned to each department (integers)
var 0..intmax: total_workload;                   % total workload to minimize

% Constraints
% --- Manpower coupling constraints ---
constraint employees[X1] + employees[X2] >= min_X1_X2;           % X1 + X2 >= 10
constraint employees[X2] + employees[X3] <= max_X2_X3;           % X2 + X3 <= 20
constraint employees[X3] >= employees[X4] + min_diff_X3_X4;      % X3 >= X4 + 5

% --- Weighted staffing constraint (float expression; convert employee vars to float) ---
constraint
  w1 * int2float(employees[X1]) +
  w2 * int2float(employees[X2]) +
  w3 * int2float(employees[X3]) +
  w4 * int2float(employees[X4]) <= weighted_max;

% --- Define total workload from per-department workloads and staffing levels ---
constraint total_workload = sum(d in DEPTS)(workload[d] * employees[d]);

% Objective
solve minimize total_workload;