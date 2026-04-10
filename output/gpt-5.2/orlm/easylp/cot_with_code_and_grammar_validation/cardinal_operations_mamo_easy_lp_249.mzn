% Parameters
int: maxTasks = 8;
int: effortX = 4;
int: effortY = 2;
int: effortZ = 3;

int: minXY = 3;
int: maxYZ = 5;

% Variables
var 0..maxTasks: X;
var 0..maxTasks: Y;
var 0..maxTasks: Z;

var 0..(effortX*maxTasks + effortY*maxTasks + effortZ*maxTasks): totalEffort;

% Constraints
constraint X + Y + Z <= maxTasks;

constraint X + Y >= minXY;

constraint Y + Z <= maxYZ;

constraint totalEffort = effortX * X + effortY * Y + effortZ * Z;

% Objective
solve minimize totalEffort;