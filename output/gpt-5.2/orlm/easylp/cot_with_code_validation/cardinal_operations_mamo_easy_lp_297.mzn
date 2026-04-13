% Parameters
int: cost_teacher = 2;
int: cost_classroom = 3;
int: cost_textbook = 4;

int: req_min_1 = 50;  % teacher + 2*classroom + 3*textbook >= 50
int: req_max_2 = 30;  % 2*teacher + classroom <= 30
int: req_min_3 = 10;  % teacher - classroom + textbook >= 10

% Variables
var 0..1000: teachers;
var 0..1000: classrooms;
var 0..1000: textbooks;

var 0..1000000: total_cost;

% Constraints
constraint teachers + 2*classrooms + 3*textbooks >= req_min_1;
constraint 2*teachers + classrooms <= req_max_2;
constraint teachers - classrooms + textbooks >= req_min_3;

constraint total_cost = cost_teacher*teachers + cost_classroom*classrooms + cost_textbook*textbooks;

% Objective
solve minimize total_cost;