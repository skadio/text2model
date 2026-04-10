% Parameters
int: num_jobs;
int: num_machines;

set of int: JOBS = 1..num_jobs;
set of int: MACHINES = 1..num_machines;

array[JOBS, MACHINES] of int: job_times;
array[JOBS, MACHINES] of int: job_order;

int: horizon = sum(j in JOBS, m in MACHINES)(job_times[j,m]);

% Variables
array[JOBS, MACHINES] of var 0..horizon: start;
array[JOBS, MACHINES] of var 0..horizon: endt;

var 0..horizon: makespan;

% Constraints
constraint
  forall(j in JOBS, m in MACHINES) (
    endt[j,m] = start[j,m] + job_times[j,m]
  );

constraint
  forall(j in JOBS, k in 1..num_machines-1) (
    start[j, job_order[j,k+1]] >= endt[j, job_order[j,k]]
  );

constraint
  forall(m in MACHINES, j1 in JOBS, j2 in JOBS where j1 < j2) (
    endt[j1,m] <= start[j2,m] \/ endt[j2,m] <= start[j1,m]
  );

constraint
  forall(j in JOBS, m in MACHINES) (
    makespan >= endt[j,m]
  );

% Objective
solve minimize makespan;