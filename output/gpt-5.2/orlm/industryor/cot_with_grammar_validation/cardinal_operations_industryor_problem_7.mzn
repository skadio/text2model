include "alldifferent.mzn";

int: NWorkers = 5;
int: NTasks = 4;

set of int: WORKERS = 1..NWorkers;
set of int: TASKS = 1..NTasks;

array[WORKERS, TASKS] of int: hours =
  array2d(WORKERS, TASKS,
    [ 9, 4, 3, 7,
      4, 6, 5, 6,
      5, 4, 7, 5,
      7, 5, 2, 3,
      10, 6, 7, 4 ]
  );

int: max_hour = max([hours[w,t] | w in WORKERS, t in TASKS]);

array[TASKS] of var WORKERS: assign;
var 0..(NTasks * max_hour): total_hours;

constraint alldifferent(assign);
constraint total_hours = sum(t in TASKS)(hours[assign[t], t]);

solve minimize total_hours;

output [
  "total_hours = ", show(total_hours), "\n",
  "assign = ", show(assign), "\n"
];