% Budget allocation optimization for teachers, students, and classrooms

int: cost_teacher = 5000;
int: cost_student = 3000;
int: cost_classroom = 10000;

% Decision variables (whole numbers)
var int: teachers;
var int: students;
var int: classrooms;

% Basic minimum requirements
constraint teachers >= 10;
constraint students >= 200;
constraint classrooms >= 5;

% Student-to-teacher ratio standard:
% For every 30 teachers, no more than 600 students => students <= 20 * teachers
constraint students * 30 <= 600 * teachers;

% Classroom capacity standard:
% At least one classroom for every 40 students => classrooms >= ceil(students/40)
constraint classrooms * 40 >= students;

% Objective: minimize total cost
var int: total_cost = cost_teacher * teachers + cost_student * students + cost_classroom * classrooms;
solve minimize total_cost;

output [
  "teachers=", show(teachers), "\n",
  "students=", show(students), "\n",
  "classrooms=", show(classrooms), "\n",
  "total_cost=", show(total_cost), "\n"
];