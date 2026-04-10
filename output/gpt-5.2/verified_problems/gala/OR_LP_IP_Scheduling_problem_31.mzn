include "globals.mzn";

int: num_jobs;
int: num_machines;

array[1..num_jobs, 1..num_machines] of int: job_times;
array[1..num_jobs, 1..num_machines] of int: job_order;

int: horizon = sum(j in 1..num_jobs, m in 1..num_machines)(job_times[j,m]);

array[1..num_jobs, 1..num_machines] of var 0..horizon: start;

% No overlap on each machine (capacity 1)
constraint
  forall(m in 1..num_machines)(
    cumulative(
      [ start[j, job_order[j,m]] | j in 1..num_jobs ],
      [ job_times[j, m]          | j in 1..num_jobs ],
      [ 1                        | j in 1..num_jobs ],
      1
    )
  );

% Precedence within each job: follow the given order (1..num_machines)
constraint
  forall(j in 1..num_jobs, k in 1..num_machines-1)(
    start[j,k] + job_times[j, job_order[j,k]] <= start[j,k+1]
  );

var 0..horizon: makespan;
constraint
  makespan = max(j in 1..num_jobs)(
    start[j, num_machines] + job_times[j, job_order[j, num_machines]]
  );

solve minimize makespan;

output [
  "makespan = ", show(makespan), "\n",
  "start = ", show(start), "\n"
];