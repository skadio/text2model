% Parameters
int: cost_teacher = 5000;
int: cost_classroom = 3000;

% Variables
var 0..1000: teachers;
var 0..1000: classrooms;
var 0..(cost_teacher*1000 + cost_classroom*1000): total_cost;

% Constraints
constraint teachers >= classrooms;
constraint 30 * teachers - classrooms >= 0;
constraint 20 * teachers + classrooms >= 100;

constraint total_cost = cost_teacher * teachers + cost_classroom * classrooms;

% Objective
solve minimize total_cost;