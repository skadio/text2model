% Parameters (with values embedded)
int: cost_teacher = 5000;
int: cost_staff = 3000;
int: cost_classroom = 200;

int: max_people = 100;

int: min_teachers = 5;
int: min_staff = 2;
int: min_classrooms = 1;

% Variables
var min_teachers..max_people: teachers;
var min_staff..max_people: staff;
var min_classrooms..max_people: classrooms;

var int: total_cost;

% Constraints
constraint teachers >= classrooms;            % at least 1 teacher per classroom
constraint staff >= 2 * classrooms;           % at least 2 staff per classroom
constraint teachers + staff <= max_people;    % combined limit

constraint total_cost = cost_teacher * teachers
                      + cost_staff * staff
                      + cost_classroom * classrooms;

% Objective
solve minimize total_cost;