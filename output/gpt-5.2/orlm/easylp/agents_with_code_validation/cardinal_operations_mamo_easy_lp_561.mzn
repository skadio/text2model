% Parameters
int: cost_teacher = 5000;          % cost per teacher ($)
int: cost_staff = 3000;            % cost per staff member ($)
int: cost_classroom = 200;         % cost per classroom ($)

int: min_teachers = 5;             % minimum teachers required
int: min_staff = 2;                % minimum staff required
int: min_classrooms = 1;           % minimum classrooms required

int: max_teacher_staff = 100;      % maximum combined teachers + staff


% Variables
var min_teachers..max_teacher_staff: teachers;     % number of teachers
var min_staff..max_teacher_staff: staff;           % number of staff
var min_classrooms..max_teacher_staff: classrooms; % number of classrooms

% Upper bound: all resources at max_teacher_staff (safe, simple bound)
var 0..(cost_teacher*max_teacher_staff
      + cost_staff*max_teacher_staff
      + cost_classroom*max_teacher_staff): total_cost;


% Constraints
% Compute total cost from selected resources
constraint
  total_cost = cost_teacher * teachers
             + cost_staff * staff
             + cost_classroom * classrooms;

% Classroom coverage by teachers: at least 1 teacher per classroom
constraint
  teachers >= classrooms;

% Classroom coverage by staff: at least 2 staff per classroom
constraint
  staff >= 2 * classrooms;

% Headcount limitation: teachers + staff cannot exceed maximum
constraint
  teachers + staff <= max_teacher_staff;

% Minimum operational requirements (redundant with variable domains, kept for clarity)
constraint teachers >= min_teachers;
constraint staff >= min_staff;
constraint classrooms >= min_classrooms;


% Objective
solve minimize total_cost;