include "globals.mzn";

% Parameters
int: num_jobs;
int: num_machines;

set of int: JOBS = 1..num_jobs;
set of int: OPS  = 1..num_machines;   % operation index within each job
set of int: MACHINES = 1..num_machines;

array[JOBS, OPS] of int: job_times;   % duration of job j at operation k
array[JOBS, OPS] of int: job_order;   % machine used by job j at operation k (a permutation of 1..num_machines)

int: horizon = sum(j in JOBS, k in OPS)(job_times[j,k]);

% Variables
array[JOBS, OPS] of var 0..horizon: start;
var 0..horizon: makespan;

% Basic validity
constraint forall(j in JOBS, k in OPS)(job_times[j,k] >= 0);
constraint forall(j in JOBS)(alldifferent([job_order[j,k] | k in OPS]));
constraint forall(j in JOBS, k in OPS)(job_order[j,k] >= 1 /\ job_order[j,k] <= num_machines);

% Precedence within each job
constraint forall(j in JOBS, k in 1..num_machines-1)(
  start[j,k+1] >= start[j,k] + job_times[j,k]
);

% Makespan definition
constraint forall(j in JOBS, k in OPS)(
  start[j,k] + job_times[j,k] <= makespan
);

% No overlap on each machine
constraint
  forall(m in MACHINES)(
    disjunctive(
      [ start[j,k] | j in JOBS, k in OPS where job_order[j,k] = m ],
      [ job_times[j,k] | j in JOBS, k in OPS where job_order[j,k] = m ]
    )
  );

% Objective
solve minimize makespan;