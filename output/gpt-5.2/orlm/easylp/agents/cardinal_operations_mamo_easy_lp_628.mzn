% Parameters
int: salary_x1 = 5000;              % Monthly salary per employee in department x1
int: salary_x2 = 4000;              % Monthly salary per employee in department x2
int: salary_x3 = 6000;              % Monthly salary per employee in department x3
int: salary_x4 = 7000;              % Monthly salary per employee in department x4

int: max_x1 = 50;                   % Upper bound on employees in x1
int: max_x2 = 60;                   % Upper bound on employees in x2
int: max_x3 = 40;                   % Upper bound on employees in x3
int: max_x4 = 40;                   % Upper bound on employees in x4

int: cap_x1_x2 = 100;               % Space limitation: x1 + x2 <= 100
int: cap_x3_x4 = 80;                % Resource constraint: x3 + x4 <= 80
int: diff_x4_x2_max = 30;           % Balance constraint: |x4 - x2| <= 30


% Variables
var 0..max_x1: x1;                  % Number of employees allocated to department x1
var 0..max_x2: x2;                  % Number of employees allocated to department x2
var 0..max_x3: x3;                  % Number of employees allocated to department x3
var 0..max_x4: x4;                  % Number of employees allocated to department x4

var 0..(salary_x1*max_x1 + salary_x2*max_x2 + salary_x3*max_x3 + salary_x4*max_x4): total_cost;
                                    % Total monthly salary cost (to be minimized)


% Constraints
% Total salary cost definition
constraint
  total_cost = salary_x1 * x1 + salary_x2 * x2 + salary_x3 * x3 + salary_x4 * x4;

% Capacity constraints across paired departments
constraint
  x1 + x2 <= cap_x1_x2;
constraint
  x3 + x4 <= cap_x3_x4;

% Supervision constraint: x1 must be at least 20 more than half of x3
% (Use 2*x1 >= x3 + 40 to keep integer linear form)
constraint
  2 * x1 >= x3 + 40;

% Balance constraint: difference between x4 and x2 should not exceed 30
constraint
  abs(x4 - x2) <= diff_x4_x2_max;


% Objective
solve minimize total_cost;