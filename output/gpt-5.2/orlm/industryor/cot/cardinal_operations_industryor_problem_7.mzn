% Parameters (with values embedded)
int: NWorkers = 5;
int: NTasks = 4;

set of int: Workers = 1..NWorkers;
set of int: Tasks = 1..NTasks;

% Task indices: 1=A, 2=B, 3=C, 4=D
array[Workers, Tasks] of int: hours =
[|  9, 4, 3, 7   % Worker I
 |  4, 6, 5, 6   % Worker II
 |  5, 4, 7, 5   % Worker III
 |  7, 5, 2, 3   % Worker IV
 | 10, 6, 7, 4   % Worker V
 |];

% Variables
array[Workers, Tasks] of var 0..1: x; % x[w,t]=1 if worker w is assigned to task t

% Constraints
constraint forall(t in Tasks) (
  sum(w in Workers)(x[w,t]) = 1
);

constraint forall(w in Workers) (
  sum(t in Tasks)(x[w,t]) <= 1
);

% Objective
var int: total_hours = sum(w in Workers, t in Tasks)(hours[w,t] * x[w,t]);
solve minimize total_hours;