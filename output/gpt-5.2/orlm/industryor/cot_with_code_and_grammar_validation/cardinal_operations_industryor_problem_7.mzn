% Parameters
int: nWorkers = 5;
int: nTasks = 4;

set of int: WORKERS = 1..nWorkers;
set of int: TASKS   = 1..nTasks;

array[WORKERS, TASKS] of int: hours =
  array2d(WORKERS, TASKS,
    [ 9, 4, 3, 7,   % Worker I
      4, 6, 5, 6,   % Worker II
      5, 4, 7, 5,   % Worker III
      7, 5, 2, 3,   % Worker IV
     10, 6, 7, 4    % Worker V
    ]);

% Variables
array[WORKERS, TASKS] of var 0..1: x; % x[w,t]=1 if worker w assigned to task t
var int: total_hours;

% Constraints
constraint
  forall(t in TASKS) (
    sum(w in WORKERS)(x[w,t]) = 1
  );

constraint
  forall(w in WORKERS) (
    sum(t in TASKS)(x[w,t]) <= 1
  );

constraint
  total_hours = sum(w in WORKERS, t in TASKS)(hours[w,t] * x[w,t]);

% Objective
solve minimize total_hours;