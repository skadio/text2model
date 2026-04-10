% Parameters
int: cost_teacher = 5000;
int: cost_staff = 3000;
int: cost_classroom = 200;

int: min_teachers = 5;
int: min_staff = 2;
int: min_classrooms = 1;

int: max_people = 100;

% Variables
var min_teachers..max_people: teachers;
var min_staff..max_people: staff;
var min_classrooms..max_people: classrooms;

var 0..(cost_teacher*max_people + cost_staff*max_people + cost_classroom*max_people): total_cost;

% Constraints
constraint teachers >= classrooms;
constraint staff >= 2 * classrooms;

constraint teachers + staff <= max_people;

constraint total_cost = cost_teacher * teachers + cost_staff * staff + cost_classroom * classrooms;

% Objective
solve minimize total_cost;