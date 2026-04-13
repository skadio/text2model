% Parameters (with values embedded)
int: max_total_tasks = 8;
int: effort_X = 4;
int: effort_Y = 2;
int: effort_Z = 3;

int: min_X_plus_Y = 3;
int: max_Y_plus_Z = 5;

% Variables
var 0..max_total_tasks: X;
var 0..max_total_tasks: Y;
var 0..max_total_tasks: Z;

% Constraints
constraint X + Y + Z <= max_total_tasks;
constraint X + Y >= min_X_plus_Y;
constraint Y + Z <= max_Y_plus_Z;

% Objective
solve minimize effort_X * X + effort_Y * Y + effort_Z * Z;