% Parameters (with values embedded)
int: timeX = 8;
int: timeY = 5;
int: maxTasks = 10;
int: effX = 2;
int: effY = 3;
int: minEff = 6;

% Variables
var 0..maxTasks: X;
var 0..maxTasks: Y;
var 0..(timeX*maxTasks + timeY*maxTasks): totalTime;

% Constraints
constraint X + Y <= maxTasks;
constraint effX * X + effY * Y >= minEff;
constraint totalTime = timeX * X + timeY * Y;

% Objective
solve minimize totalTime;