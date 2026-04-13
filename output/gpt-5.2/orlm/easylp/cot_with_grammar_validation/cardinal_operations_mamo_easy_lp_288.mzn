int: cost_teacher = 5000;
int: cost_student = 3000;
int: cost_classroom = 10000;

int: min_teachers = 10;
int: min_students = 200;
int: min_classrooms = 5;

int: teachers_per_ratio = 30;
int: max_students_per_ratio = 600;

int: students_per_classroom = 40;

var min_teachers..10000: T;
var min_students..1000000: S;
var min_classrooms..100000: C;

var int: total_cost;

constraint S * teachers_per_ratio <= max_students_per_ratio * T;
constraint C * students_per_classroom >= S;

constraint total_cost = cost_teacher * T + cost_student * S + cost_classroom * C;

solve minimize total_cost;

output [
  "T=", show(T), " S=", show(S), " C=", show(C), " total_cost=", show(total_cost)
];