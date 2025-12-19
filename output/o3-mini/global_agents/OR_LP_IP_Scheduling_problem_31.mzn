include "globals.mzn";

/* Data parameters */
int: num_jobs;
int: num_machines;
array[1..num_jobs, 1..num_machines] of int: job_times;   % processing times for each job on each machine
array[1..num_jobs, 1..num_machines] of int: job_order;   % for each machine m, job_order[*,m] lists jobs in the order they must be processed

/* Decision variables: start time for each job on each machine */
array[1..num_jobs, 1..num_machines] of var 0..10000: start;

/* Makespan: the maximum completion time of the last operation of each job */
var 0..10000: makespan;

/* 1. Job sequencing constraints: For each job, operations must be processed in the given order.
   Here, we assume that each job is processed on the machines in the natural order 1,2,...,num_machines.
   (i.e. job j must complete on machine m before starting on machine m+1) */
constraint
  forall(j in 1..num_jobs, m in 1..num_machines-1) (
    start[j, m] + job_times[j, m] <= start[j, m+1]
  );

/* 2. Machine capacity constraints:
   Each machine can process at most one job at a time. We use a cumulative constraint for every machine m.
   For each machine, the tasks’ start times, durations and a fixed resource usage (1) combine with capacity 1. */
constraint
  forall(m in 1..num_machines) (
    cumulative([ start[j, m] | j in 1..num_jobs ],
               [ job_times[j, m] | j in 1..num_jobs ],
               [ 1 | j in 1..num_jobs ],
               1)
  );

/* 3. Machine order constraints:
   For each machine m, the jobs must start in (non-decreasing) order as given by job_order.
   That is, the sequence of start times for the tasks on machine m,
   arranged in the order specified by job_order[*, m], is increasing. */
constraint
  forall(m in 1..num_machines) (
    increasing([ start[job_order[j, m], m] | j in 1..num_jobs ])
  );

/* 4. Define the makespan as the maximum completion time over all jobs.
   The completion time of job j is its start time on machine num_machines plus its processing time there. */
constraint
  makespan = max(j in 1..num_jobs)( start[j, num_machines] + job_times[j, num_machines] );

/* Solve: Minimize the makespan */
solve minimize makespan;

output [
  "Makespan = ", show(makespan), "\n",
  "Start times:\n",
  concat([ "Job " ++ show(j) ++ ": " ++ show([ start[j, m] | m in 1..num_machines ]) ++ "\n" | j in 1..num_jobs ])
];