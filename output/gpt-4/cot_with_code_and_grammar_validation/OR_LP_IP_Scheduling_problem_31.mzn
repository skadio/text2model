% Parameters
int: num_jobs;
int: num_machines;
array[1..num_jobs, 1..num_machines] of int: job_times;
array[1..num_jobs, 1..num_machines] of int: job_order;

% Variables
array[1..num_jobs, 1..num_machines] of var 0..sum([job_times[i,j] | i in 1..num_jobs, j in 1..num_machines]): start_times;
var 0..sum([job_times[i,j] | i in 1..num_jobs, j in 1..num_machines]): end_time;

% Constraints
% Each job must start after the previous job on the same machine has finished
constraint forall(j in 1..num_jobs, m in 2..num_machines) (
    start_times[j, m] >= start_times[j, m-1] + job_times[j, m-1]
);

% Jobs must be processed in the correct order on each machine
constraint forall(m in 1..num_machines, j in 1..num_jobs-1) (
    start_times[job_order[j+1, m], m] >= start_times[job_order[j, m], m] + job_times[job_order[j, m], m]
);

% The end time is the maximum end time of all jobs
constraint end_time = max([start_times[j, num_machines] + job_times[j, num_machines] | j in 1..num_jobs]);

% Objective
solve minimize end_time;