include "alldifferent.mzn";

% Parameters
int: NWorkers = 5;
int: NTasks = 4;

set of int: WORKERS = 1..NWorkers;
set of int: TASKS   = 1..NTasks;

array[WORKERS, TASKS] of int: hours =
  [|  9, 4, 3, 7
   |  4, 6, 5, 6
   |  5, 4, 7, 5
   |  7, 5, 2, 3
   | 10, 6, 7, 4 |];

% Variables
array[TASKS] of var WORKERS: assign;  % worker assigned to each task
var 0..sum(w in WORKERS, t in TASKS)(hours[w,t]): total_hours;

% Constraints
constraint all_different(assign);
constraint total_hours = sum(t in TASKS)(hours[assign[t], t]);

% Objective
solve minimize total_hours;

output [
  "total_hours = ", show(total_hours), "\n",
  "assign (task->worker) = ", show(assign), "\n"
];