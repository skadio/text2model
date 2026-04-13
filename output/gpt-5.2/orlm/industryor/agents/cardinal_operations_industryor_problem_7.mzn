% Parameters
% Number of workers and tasks
int: nWorkers = 5;
int: nTasks   = 4;

set of int: WORKERS = 1..nWorkers;
set of int: TASKS   = 1..nTasks;

% Time (hours) required if worker w performs task t
% Workers: 1=I, 2=II, 3=III, 4=IV, 5=V
% Tasks:   1=A, 2=B, 3=C, 4=D
array[WORKERS, TASKS] of int: hours =
  [|  9, 4, 3, 7
   |  4, 6, 5, 6
   |  5, 4, 7, 5
   |  7, 5, 2, 3
   | 10, 6, 7, 4 |];

% Variables
% assign[w,t] = 1 if worker w is assigned to task t, else 0
array[WORKERS, TASKS] of var 0..1: assign;

% totalHours = total working hours for the chosen assignment
var 0..(max(hours) * nTasks): totalHours;

% Constraints
% Each task must be assigned to exactly one worker
constraint
  forall(t in TASKS) (
    sum(w in WORKERS)(assign[w, t]) = 1
  );

% Each worker can perform at most one task (so exactly 4 of 5 workers are used)
constraint
  forall(w in WORKERS) (
    sum(t in TASKS)(assign[w, t]) <= 1
  );

% Define totalHours as the sum of hours for all chosen (worker, task) assignments
constraint
  totalHours =
    sum(w in WORKERS, t in TASKS)(
      hours[w, t] * assign[w, t]
    );

% Objective
solve minimize totalHours;