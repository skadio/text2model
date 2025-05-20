include "globals.mzn";

% Parameters
int: num_jobs; % Number of jobs
int: num_machines; % Number of machines
array[1..num_jobs, 1..num_machines] of int: job_times; % Job times
array[1..num_jobs, 1..num_machines] of int: job_order; % Job order

% Variables
array[1..num_jobs, 1..num_machines] of var 0..sum(job_times): start_times; % Start times
var 0..sum(job_times): end_time; % End time

% Constraints
constraint forall(j in 1..num_jobs, m in 2..num_machines) (
    start_times[j, m] >= start_times[j, m-1] + job_times[j, m-1]
);

constraint forall(m in 1..num_machines, j1 in 1..num_jobs, j2 in j1+1..num_jobs) (
    (start_times[j1, m] + job_times[j1, m] <= start_times[j2, m]) \/
    (start_times[j2, m] + job_times[j2, m] <= start_times[j1, m])
);

constraint forall(j in 1..num_jobs) (
    end_time >= start_times[j, num_machines] + job_times[j, num_machines]
);

% Objective
solve minimize end_time;

% Output
output [ "Job " ++ show(j) ++ " starts at time " ++ show(start_times[j, m]) ++ " on machine " ++ show(m) ++ "\n" | j in 1..num_jobs, m in 1..num_machines ];