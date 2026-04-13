% Parameters
int: H = 24;
set of int: Tasks = 1..4;
array[Tasks] of int: workload = [1, 2, 3, 4];

% Variables
array[Tasks] of var 0..H: start;

% Constraints
constraint start[1] >= 5;
constraint abs(start[2] - start[1]) <= 8;
constraint abs(start[3] - start[2]) >= 10;
constraint abs(start[4] - start[3]) <= 15;

% Objective
var int: total_workload = sum(t in Tasks)(workload[t]);
solve minimize total_workload;