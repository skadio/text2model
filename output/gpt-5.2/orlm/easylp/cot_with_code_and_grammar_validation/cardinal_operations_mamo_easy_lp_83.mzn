% Parameters
int: timeX = 8;
int: timeY = 5;
int: maxTasks = 10;
int: minEff = 6;

% Variables
var 0..maxTasks: x;  % number of tasks of type X
var 0..maxTasks: y;  % number of tasks of type Y
var 0..(timeX*maxTasks + timeY*maxTasks): totalTime;

% Constraints
constraint x + y <= maxTasks;
constraint 2*x + 3*y >= minEff;
constraint totalTime = timeX*x + timeY*y;

% Objective
solve minimize totalTime;