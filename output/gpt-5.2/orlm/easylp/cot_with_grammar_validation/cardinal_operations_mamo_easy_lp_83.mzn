% Parameters
int: time_X = 8;
int: time_Y = 5;
int: max_tasks = 10;
int: min_effectiveness = 6;

% Variables
var 0..max_tasks: X;
var 0..max_tasks: Y;
var 0..(time_X*max_tasks + time_Y*max_tasks): total_time;

% Constraints
constraint X + Y <= max_tasks;
constraint 2*X + 3*Y >= min_effectiveness;
constraint total_time = time_X*X + time_Y*Y;

% Objective
solve minimize total_time;