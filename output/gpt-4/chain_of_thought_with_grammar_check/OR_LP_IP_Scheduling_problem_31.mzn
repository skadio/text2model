% Parameters
int: num_jobs;
int: num_machines;
array[1..num_jobs, 1..num_machines] of int: job_times;
array[1..num_jobs, 1..num_machines] of int: job_order;

% Variables
array[1..num_jobs, 1..num_machines] of var 0..sum(job_times): start_times;

% Constraints
% Each job must start after the previous one on the same machine
constraint forall(j in 1..num_jobs, m in 2..num_machines) (
    start_times[j, m] >= start_times[j, m-1] + job_times[j, m-1]
);

% No two jobs can be processed at the same time on the same machine
constraint forall(m in 1..num_machines, j1 in 1..num_jobs, j2 in j1+1..num_jobs) (
    (start_times[j1, m] + job_times[j1, m] <= start_times[j2, m]) \/
    (start_times[j2, m] + job_times[j2, m] <= start_times[j1, m])
);

% The order of jobs on each machine must be respected
constraint forall(m in 1..num_machines, o in 1..num_jobs-1) (
    let { var int: j1 = job_order[o, m]; var int: j2 = job_order[o+1, m] } in
    start_times[j1, m] + job_times[j1, m] <= start_times[j2, m]
);

% Objective
var int: end_time = max(array1d(1..num_jobs*num_machines, [start_times[j, m] + job_times[j, m] | j in 1..num_jobs, m in 1..num_machines]));
solve minimize end_time;