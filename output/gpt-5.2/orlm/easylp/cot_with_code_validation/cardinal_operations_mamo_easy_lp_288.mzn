% Parameters
int: cost_teacher = 5000;
int: cost_student = 3000;
int: cost_classroom = 10000;

int: min_teachers = 10;
int: min_students = 200;
int: min_classrooms = 5;

int: teachers_per_ratio = 30;
int: max_students_per_ratio = 600;

int: students_per_classroom = 40;

% Variables
var int: teachers;
var int: students;
var int: classrooms;

var int: total_cost;

% Constraints
constraint teachers >= min_teachers;
constraint students >= min_students;
constraint classrooms >= min_classrooms;

% For every 30 teachers, no more than 600 students:
% students / teachers <= 600 / 30  => 30*students <= 600*teachers
constraint teachers_per_ratio * students <= max_students_per_ratio * teachers;

% At least one classroom for every 40 students:
% classrooms >= students / 40  => 40*classrooms >= students
constraint students_per_classroom * classrooms >= students;

% Total cost
constraint total_cost = cost_teacher * teachers
                      + cost_student * students
                      + cost_classroom * classrooms;

% Objective
solve minimize total_cost;