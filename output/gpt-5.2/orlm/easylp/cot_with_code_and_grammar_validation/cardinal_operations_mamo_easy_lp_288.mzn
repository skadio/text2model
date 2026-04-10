% Parameters (embedded data)
int: cost_teacher = 5000;
int: cost_student = 3000;
int: cost_classroom = 10000;

int: min_teachers = 10;
int: min_students = 200;
int: min_classrooms = 5;

% Derived ratio parameters
int: students_per_teacher_cap = 20;   % students <= 20 * teachers  (from 600 per 30 teachers)
int: students_per_classroom = 40;     % classrooms >= students / 40  <=> 40*classrooms >= students

% Decision variables (integers)
var min_teachers..10000: teachers;
var min_students..200000: students;
var min_classrooms..10000: classrooms;

var 0..1000000000: total_cost;

% Constraints
constraint students <= students_per_teacher_cap * teachers;
constraint students <= students_per_classroom * classrooms;

constraint total_cost =
    cost_teacher * teachers
  + cost_student * students
  + cost_classroom * classrooms;

% Objective
solve minimize total_cost;

output [
  "teachers=", show(teachers), "\n",
  "students=", show(students), "\n",
  "classrooms=", show(classrooms), "\n",
  "total_cost=", show(total_cost), "\n"
];