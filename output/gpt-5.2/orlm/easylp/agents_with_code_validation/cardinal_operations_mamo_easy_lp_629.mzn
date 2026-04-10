% Parameters
int: salary_x1 = 5000; % salary per employee in department x1
int: salary_x2 = 6000; % salary per employee in department x2
int: salary_x3 = 7000; % salary per employee in department x3
int: salary_x4 = 8000; % salary per employee in department x4

int: max_x1_x2 = 40;        % upper bound on x1 + x2
int: max_x3_x4 = 30;        % upper bound on x3 + x4
int: min_diff_x1_x3 = 10;   % x1 must be at least this many more than x3
int: min_diff_x2_x4 = 5;    % x2 must be at least this many more than x4

int: x1_lb = 0;  int: x1_ub = 20; % bounds for x1
int: x2_lb = 0;  int: x2_ub = 20; % bounds for x2
int: x3_lb = 0;  int: x3_ub = 15; % bounds for x3
int: x4_lb = 0;  int: x4_ub = 15; % bounds for x4


% Variables
var x1_lb..x1_ub: x1; % number of employees in department x1
var x2_lb..x2_ub: x2; % number of employees in department x2
var x3_lb..x3_ub: x3; % number of employees in department x3
var x4_lb..x4_ub: x4; % number of employees in department x4

var int: total_payroll; % total payroll cost (objective)


% Constraints
% Department capacity bounds are already enforced by variable domains (x1..x4).

% Total payroll definition (linking variable)
constraint
  total_payroll =
    salary_x1 * x1 +
    salary_x2 * x2 +
    salary_x3 * x3 +
    salary_x4 * x4;

% Budget/combined headcount limitations
constraint x1 + x2 <= max_x1_x2;
constraint x3 + x4 <= max_x3_x4;

% Balance requirements across departments (minimum differences)
constraint x1 - x3 >= min_diff_x1_x3;
constraint x2 - x4 >= min_diff_x2_x4;


% Objective
solve minimize total_payroll;