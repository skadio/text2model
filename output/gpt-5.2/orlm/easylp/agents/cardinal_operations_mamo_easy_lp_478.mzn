% Parameters
int: cost_x = 500;                 % Cost per student in Program X ($)
int: cost_y = 300;                 % Cost per student in Program Y ($)
int: max_total_students = 25;      % Maximum total students across both programs
int: min_students_x = 10;          % Minimum students required in Program X
int: min_students_y = 5;           % Minimum students required in Program Y

% Variables
var min_students_x..max_total_students: students_x;  % Students admitted to Program X
var min_students_y..max_total_students: students_y;  % Students admitted to Program Y
var 0..(cost_x*max_total_students + cost_y*max_total_students): total_cost; % Total cost ($)

% Constraints
% Capacity constraint: total admitted students across both programs cannot exceed the maximum
constraint
  students_x + students_y <= max_total_students;

% Minimum enrollment requirements (redundant with variable domains but kept for clarity/robustness)
constraint
  students_x >= min_students_x;
constraint
  students_y >= min_students_y;

% Cost definition: total cost is determined by per-student costs and enrollments
constraint
  total_cost = cost_x * students_x + cost_y * students_y;

% Objective
solve minimize total_cost;