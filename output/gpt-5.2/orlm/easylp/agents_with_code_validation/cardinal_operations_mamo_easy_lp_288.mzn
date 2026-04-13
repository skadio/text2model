% Parameters
int: cost_per_teacher = 5000;      % $ per teacher
int: cost_per_student = 3000;      % $ per student
int: cost_per_classroom = 10000;   % $ per classroom

int: min_teachers = 10;            % minimum teachers required
int: min_students = 200;           % minimum students required
int: min_classrooms = 5;           % minimum classrooms required

int: teachers_ratio_unit = 30;     % ratio statement: per 30 teachers
int: max_students_per_unit = 600;  % no more than 600 students per 30 teachers

int: students_per_classroom = 40;  % at least 1 classroom per 40 students


% Variables
var int: teachers;                 % number of teachers hired
var int: students;                 % number of students enrolled
var int: classrooms;               % number of classrooms maintained

var int: total_cost;               % total cost in dollars


% Constraints
% --- Minimum staffing/enrollment/facility requirements ---
constraint teachers >= min_teachers;
constraint students >= min_students;
constraint classrooms >= min_classrooms;

% --- Student-to-teacher ratio: for every 30 teachers, at most 600 students ---
% Cross-multiplied to keep everything integral: students * 30 <= teachers * 600
constraint students * teachers_ratio_unit <= teachers * max_students_per_unit;

% --- Classroom capacity: at least 1 classroom per 40 students ---
% Implemented without floats: 40 * classrooms >= students
constraint students_per_classroom * classrooms >= students;

% --- Total cost definition ---
constraint total_cost =
  cost_per_teacher * teachers +
  cost_per_student * students +
  cost_per_classroom * classrooms;


% Objective
solve minimize total_cost;