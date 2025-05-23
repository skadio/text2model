include "globals.mzn";

int: num_jobs;
int: num_machines;

array[1..num_jobs, 1..num_machines] of int: job_times;
array[1..num_jobs, 1..num_machines] of int: job_order;

int: max_time = sum(j in 1..num_jobs, s in 1..num_machines)(job_times[j, s]);

set of int: JOBS     = 1..num_jobs;
set of int: MACHINES = 1..num_machines;
set of int: STEPS    = 1..num_machines;

int: horizon = max_time;

array[JOBS, STEPS] of var 0..horizon: start_time;
var 0..horizon: makespan;

constraint
  forall(j in JOBS, s in 1..(num_machines - 1)) (
    start_time[j, s] + job_times[j, s] <= start_time[j, s + 1]
  );

constraint
  forall(m in MACHINES)(
    disjunctive(
      [ start_time[j, s] | j in JOBS, s in STEPS where job_order[j, s] == m ],
      [ job_times[j, s]  | j in JOBS, s in STEPS where job_order[j, s] == m ]
    )
  );

constraint
  forall(j in JOBS, s in STEPS)(
    makespan >= start_time[j, s] + job_times[j, s]
  );

solve minimize makespan;