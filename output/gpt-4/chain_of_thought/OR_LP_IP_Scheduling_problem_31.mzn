% Parameters
int: num_jobs;
int: num_machines;
array[1..num_jobs, 1..num_machines] of int: job_times;
array[1..num_jobs, 1..num_machines] of int: job_order;

% Variables
array[1..num_jobs, 1..num_machines] of var 0..sum(job_times): start_times;

% Constraints
% Each job must start after the previous job on the same machine has finished
constraint forall(j in 1..num_jobs, m in 2..num_machines) (
    start_times[j, m] >= start_times[j, m-1] + job_times[j, m-1]
);

% Jobs must not overlap on the same machine
constraint forall(m in 1..num_machines, j1 in 1..num_jobs, j2 in j1+1..num_jobs) (
    (start_times[j1, m] + job_times[j1, m] <= start_times[j2, m]) \/ 
    (start_times[j2, m] + job_times[j2, m] <= start_times[j1, m])
);

% Jobs must be processed in the correct order across machines
constraint forall(j in 1..num_jobs, m in 1..num_machines) (
    start_times[j, m] >= sum(i in 1..(job_order[j, m]-1)) (job_times[j, i])
);

% Objective
% Minimize the earliest end time
var int: end_time = max(j in 1..num_jobs, m in 1..num_machines) (start_times[j, m] + job_times[j, m]);
solve minimize end_time;