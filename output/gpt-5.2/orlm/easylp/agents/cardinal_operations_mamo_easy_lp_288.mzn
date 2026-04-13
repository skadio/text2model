% Parameters
int: cost_per_teacher = 5000;      % dollars per teacher
int: cost_per_student = 3000;      % dollars per student
int: cost_per_classroom = 10000;   % dollars per classroom

int: min_teachers = 10;            % minimum teachers to hire
int: min_students = 200;           % minimum students to enroll
int: min_classrooms = 5;           % minimum classrooms to maintain

int: teachers_ratio = 30;          % ratio unit: 30 teachers
int: max_students_per_ratio = 600; % max students per 30 teachers

int: students_per_classroom = 40;  % at least 1 classroom per 40 students

% Upper bounds (safe, keeps model bounded for search)
int: max_teachers = 1000;
int: max_students = 20000;
int: max_classrooms = 1000;

% Variables
var min_teachers..max_teachers: teachers;        % number of teachers hired
var min_students..max_students: students;        % number of students enrolled
var min_classrooms..max_classrooms: classrooms;  % number of classrooms maintained

var int: total_cost;                             % total cost in dollars

% Constraints

% Total cost accounting
constraint
  total_cost = cost_per_teacher * teachers
             + cost_per_student * students
             + cost_per_classroom * classrooms;

% Student-to-teacher ratio:
% For every 30 teachers, at most 600 students
% 30*students <= 600*teachers
constraint
  teachers_ratio * students <= max_students_per_ratio * teachers;

% Classroom requirement:
% At least 1 classroom per 40 students
% 40*classrooms >= students
constraint
  students_per_classroom * classrooms >= students;

% Objective
solve minimize total_cost;