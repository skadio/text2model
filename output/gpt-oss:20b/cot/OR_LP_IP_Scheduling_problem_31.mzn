% Parameters
int: num_jobs;
int: num_machines;
array[1..num_jobs, 1..num_machines] of int: job_times;
array[1..num_jobs, 1..num_machines] of int: job_order;

% Variables
array[1..num_jobs, 1..num_machines] of var int: start;
array[1..num_jobs, 1..num_machines] of var int: end = [start[j,m] + job_times[j,m] | j in 1..num_jobs, m in 1..num_machines];
var int: makespan;

% Constraints
constraint forall(j in 1..num_jobs, m in 1..num_machines) (
    start[j,m] >= 0
);

constraint forall(j in 1..num_jobs, m in 2..num_machines) (
    start[j,m] >= end[j,m-1]
);

constraint forall(m in 1..num_machines, k in 1..num_jobs-1) (
    let
        job_a = job_order[k,m];
        job_b = job_order[k+1,m];
    in
        end[job_a,m] <= start[job_b,m]
);

constraint forall(j in 1..num_jobs, m in 1..num_machines) (
    makespan >= end[j,m]
);

% Objective
solve minimize makespan;