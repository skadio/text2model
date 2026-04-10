% Parameters
int: total_tasks = 8;
int: effort_X = 4;
int: effort_Y = 2;
int: effort_Z = 3;
int: min_XY = 3;
int: max_YZ = 5;

% Variables
var 0..total_tasks: X;
var 0..total_tasks: Y;
var 0..total_tasks: Z;

var 0..(effort_X*total_tasks + effort_Y*total_tasks + effort_Z*total_tasks): total_effort;

% Constraints
constraint X + Y + Z = total_tasks;
constraint X + Y >= min_XY;
constraint Y + Z <= max_YZ;

constraint total_effort = effort_X*X + effort_Y*Y + effort_Z*Z;

% Objective
solve minimize total_effort;