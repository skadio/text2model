% Parameters (with values embedded)
int: nTasks = 4;
set of int: Tasks = 1..nTasks;

% Workloads for t1..t4
array[Tasks] of int: workload = [1, 2, 3, 4];

% Time horizon (single day, hours 0..23)
int: H = 24;
set of int: Hours = 0..(H-1);

% Variables
array[Tasks] of var Hours: start;

% Constraints
constraint start[1] >= 5;

% |start[t2] - start[t1]| <= 8
constraint abs(start[2] - start[1]) <= 8;

% |start[t3] - start[t2]| >= 10
constraint abs(start[3] - start[2]) >= 10;

% |start[t4] - start[t3]| <= 15
constraint abs(start[4] - start[3]) <= 15;

% Objective
var int: total_workload = sum(t in Tasks)(workload[t]);
solve minimize total_workload;