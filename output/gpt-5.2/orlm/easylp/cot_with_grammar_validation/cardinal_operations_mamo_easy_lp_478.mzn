% Parameters
int: cost_X = 500;
int: cost_Y = 300;
int: max_total_students = 25;
int: min_X = 10;
int: min_Y = 5;

% Variables
var min_X..max_total_students: x; % students in Program X
var min_Y..max_total_students: y; % students in Program Y
var 0..(cost_X*max_total_students + cost_Y*max_total_students): total_cost;

% Constraints
constraint x + y <= max_total_students;
constraint total_cost = cost_X * x + cost_Y * y;

% Objective
solve minimize total_cost;