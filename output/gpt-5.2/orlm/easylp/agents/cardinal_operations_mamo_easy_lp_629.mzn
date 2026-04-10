% Parameters
% Salary cost per employee in each department (given directly in the problem)
int: salary_x1 = 5000;
int: salary_x2 = 6000;
int: salary_x3 = 7000;
int: salary_x4 = 8000;

% Capacity bounds for each department
int: x1_min = 0;
int: x1_max = 20;
int: x2_min = 0;
int: x2_max = 20;
int: x3_min = 0;
int: x3_max = 15;
int: x4_min = 0;
int: x4_max = 15;

% Cross-department constraints
int: max_x1_x2 = 40;  % x1 + x2 <= 40
int: max_x3_x4 = 30;  % x3 + x4 <= 30
int: diff_x1_x3 = 10; % x1 >= x3 + 10
int: diff_x2_x4 = 5;  % x2 >= x4 + 5


% Variables
% Number of employees allocated to each department (must be whole numbers)
var x1_min..x1_max: x1;
var x2_min..x2_max: x2;
var x3_min..x3_max: x3;
var x4_min..x4_max: x4;

% Total payroll cost (bounded using min/max possible cost from variable bounds)
var (salary_x1*x1_min + salary_x2*x2_min + salary_x3*x3_min + salary_x4*x4_min)
  .. (salary_x1*x1_max + salary_x2*x2_max + salary_x3*x3_max + salary_x4*x4_max): total_payroll;


% Constraints
% Department capacity bounds are already enforced by variable domains (x1..x4).

% Cross-department maximum staffing constraints
constraint x1 + x2 <= max_x1_x2;   % Combined employees in departments x1 and x2 cannot exceed 40
constraint x3 + x4 <= max_x3_x4;   % Combined employees in departments x3 and x4 cannot exceed 30

% Balance / difference constraints between departments
constraint x1 >= x3 + diff_x1_x3;  % At least 10 more employees in x1 than in x3
constraint x2 >= x4 + diff_x2_x4;  % At least 5 more employees in x2 than in x4

% Total payroll definition (link decision variables to total cost)
constraint
  total_payroll =
    salary_x1 * x1 +
    salary_x2 * x2 +
    salary_x3 * x3 +
    salary_x4 * x4;


% Objective
solve minimize total_payroll;