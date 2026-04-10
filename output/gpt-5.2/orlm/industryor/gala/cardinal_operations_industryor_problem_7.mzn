include "globals.mzn";

/% Problem data (embedded) %/
int: nTasks = 4;
int: nWorkers = 5;

set of int: Tasks = 1..nTasks;
set of int: Workers = 1..nWorkers;

/% time[w,t] = hours for worker w to do task t
   Tasks: 1=A, 2=B, 3=C, 4=D
   Workers: 1=I, 2=II, 3=III, 4=IV, 5=V
%/
array[Workers, Tasks] of int: time =
 [|  9, 4, 3, 7   % I
  |  4, 6, 5, 6   % II
  |  5, 4, 7, 5   % III
  |  7, 5, 2, 3   % IV
  | 10, 6, 7, 4   % V
  |];

/% Decision variables: assign one distinct worker to each task (one worker left unused) %/
array[Tasks] of var Workers: worker_for_task;
constraint all_different(worker_for_task);

/% Objective: minimize total hours %/
var int: total_hours =
  sum(t in Tasks)( time[worker_for_task[t], t] );

solve minimize total_hours;

/% Output %/
array[Tasks] of string: taskName = ["A","B","C","D"];
array[Workers] of string: workerName = ["I","II","III","IV","V"];

output [
  "Total hours = ", show(total_hours), "\n",
  "Assignment:\n"
] ++
[
  "  Task ", taskName[t], " -> Worker ", workerName[fix(worker_for_task[t])],
  " (", show(time[fix(worker_for_task[t]), t]), " h)\n"
  | t in Tasks
];