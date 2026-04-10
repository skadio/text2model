include "globals.mzn";

/* Data (embedded from problem statement) */
int: cost_teacher   = 5000;
int: cost_student   = 3000;
int: cost_classroom = 10000;

int: min_teachers   = 10;
int: min_students   = 200;
int: min_classrooms = 5;

/* Decision variables (whole numbers) */
var min_teachers..1000000: teachers;
var min_students..1000000: students;
var min_classrooms..1000000: classrooms;

/* Constraints */
/* For every 30 teachers, no more than 600 students:
   students/teachers <= 600/30 = 20  => students <= 20 * teachers */
constraint students <= 20 * teachers;

/* At least one classroom for every 40 students:
   classrooms >= ceil(students/40)  <=> 40*classrooms >= students */
constraint 40 * classrooms >= students;

/* Objective: minimize total cost */
var int: total_cost = cost_teacher * teachers
                    + cost_student * students
                    + cost_classroom * classrooms;

solve minimize total_cost;

output [
  "teachers = ", show(teachers), "\n",
  "students = ", show(students), "\n",
  "classrooms = ", show(classrooms), "\n",
  "total_cost = ", show(total_cost), "\n"
];