% HR allocation between departments X and Y
% Embed all data directly (no .dzn)

int: min_hires = 10;
int: effort_limit = 40;

int: effort_x = 3;
int: effort_y = 4;

int: salary_x = 50000;
int: salary_y = 60000;

% Decision variables (nonnegative integers)
var 0..effort_limit: X;
var 0..effort_limit: Y;

% Constraints
constraint X + Y >= min_hires;
constraint effort_x * X + effort_y * Y <= effort_limit;

% Objective: minimize total annual salary cost
var int: total_salary = salary_x * X + salary_y * Y;

solve minimize total_salary;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Minimum total annual salary ($) = ", show(total_salary), "\n"
];