% Parameters (with values embedded)
int: cost_teacher = 5000;
int: cost_student = 3000;
int: cost_classroom = 10000;

int: min_teachers = 10;
int: min_students = 200;
int: min_classrooms = 5;

% Ratio constraints:
% For every 30 teachers, no more than 600 students  => students <= 20 * teachers
int: students_per_teacher_limit = 20;

% At least 1 classroom per 40 students => classrooms >= ceil(students/40)
int: students_per_classroom = 40;

% Variable bounds (safe upper bounds for search)
int: max_teachers = 1000;
int: max_students = 20000;
int: max_classrooms = 2000;

% Variables
var min_teachers..max_teachers: teachers;
var min_students..max_students: students;
var min_classrooms..max_classrooms: classrooms;

var int: total_cost;

% Constraints
constraint students <= students_per_teacher_limit * teachers;

constraint classrooms * students_per_classroom >= students;

constraint total_cost =
  cost_teacher * teachers +
  cost_student * students +
  cost_classroom * classrooms;

% Objective
solve minimize total_cost;