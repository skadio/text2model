% Resource allocation optimization for an educational institution
% All data embedded directly in this model.

int: cost_teacher = 5000;
int: cost_staff = 3000;
int: cost_classroom = 200;

int: max_people = 100;

int: min_teachers = 5;
int: min_staff = 2;
int: min_classrooms = 1;

var int: teachers;
var int: staff;
var int: classrooms;

constraint teachers >= min_teachers;
constraint staff >= min_staff;
constraint classrooms >= min_classrooms;

% For every classroom: at least 1 teacher and at least 2 staff
constraint teachers >= classrooms;
constraint staff >= 2 * classrooms;

% Total teachers + staff limit
constraint teachers + staff <= max_people;

var int: total_cost = cost_teacher * teachers + cost_staff * staff + cost_classroom * classrooms;

solve minimize total_cost;

output [
  "teachers=", show(teachers), "\n",
  "staff=", show(staff), "\n",
  "classrooms=", show(classrooms), "\n",
  "min_total_cost=", show(total_cost), "\n"
];