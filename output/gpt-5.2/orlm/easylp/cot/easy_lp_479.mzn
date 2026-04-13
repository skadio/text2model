% Parameters (with values embedded)
int: cost_teacher = 5000;
int: cost_classroom = 3000;

% Variables
var 0..1000: teachers;
var 0..1000: classrooms;

% Constraints
constraint teachers >= classrooms;
constraint 30 * teachers - classrooms >= 0;
constraint 20 * teachers + classrooms >= 100;

% Objective
solve minimize cost_teacher * teachers + cost_classroom * classrooms;