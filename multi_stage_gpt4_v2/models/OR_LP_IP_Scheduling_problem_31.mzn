% Parameters
int: num_jobs; % Number of jobs to be scheduled
int: num_machines; % Number of machines available for job scheduling
array[1..num_jobs, 1..num_machines] of int: job_times; % Matrix representing the time each job takes on each machine
array[1..num_jobs, 1..num_machines] of int: job_order; % Matrix representing the order of jobs on each machine

% Variables
% Start time for each job on each machine
array[1..num_jobs, 1..num_machines] of var 0..sum(job_times): start_times; 

% End time for each job on each machine
array[1..num_jobs, 1..num_machines] of var 0..sum(job_times): end_times; 

% The earliest end time across all jobs and machines
var 0..sum(job_times): earliest_end_time; 

% Constraints

% The end time for each job on each machine is the start time plus the job time
constraint forall(i in 1..num_jobs, j in 1..num_machines) (
    end_times[i,j] = start_times[i,j] + job_times[i,j]
);

% The start time for each job on each machine is after the end time of the previous job on the same machine
constraint forall(i in 1..num_jobs, j in 2..num_machines) (
    start_times[i,j] >= end_times[i,j-1]
);

% The start time for each job on each machine is after the end time of the previous job on the same machine according to the job order
constraint forall(i in 1..num_jobs, j in 2..num_machines) (
    if job_order[i,j] > 1 then
        start_times[i,j] >= end_times[i,job_order[i,j-1]]
    else
        true
    endif
);

% The earliest end time is the maximum end time across all jobs and machines
constraint earliest_end_time = max(i in 1..num_jobs, j in 1..num_machines) (end_times[i,j]);

% Objective
solve minimize earliest_end_time;