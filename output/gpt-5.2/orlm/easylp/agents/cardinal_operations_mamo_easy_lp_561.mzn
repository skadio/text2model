% Parameters
% Unit costs (USD)
int: cost_teacher = 5000;
int: cost_staff = 3000;
int: cost_classroom = 200;

% Operational minimums
int: min_teachers = 5;
int: min_staff = 2;
int: min_classrooms = 1;

% Staffing constraint
int: max_teacher_staff_total = 100;

% Variables
% Decision variables (nonnegative integers via explicit lower bounds in constraints)
var int: teachers;     % number of teachers employed
var int: staff;        % number of staff employed
var int: classrooms;   % number of classrooms kept open

% Objective helper variable
var int: total_cost;   % total cost in USD

% Constraints
% Minimum operational levels (lower bounds)
constraint teachers >= min_teachers;
constraint staff >= min_staff;
constraint classrooms >= min_classrooms;

% Per-classroom coverage requirements
constraint teachers >= classrooms;      % at least 1 teacher per classroom
constraint staff >= 2 * classrooms;     % at least 2 staff per classroom

% Combined staffing cap (budgetary limitation)
constraint teachers + staff <= max_teacher_staff_total;

% Total cost definition (linking variable)
constraint total_cost =
    cost_teacher * teachers
  + cost_staff * staff
  + cost_classroom * classrooms;

% Objective
solve minimize total_cost;