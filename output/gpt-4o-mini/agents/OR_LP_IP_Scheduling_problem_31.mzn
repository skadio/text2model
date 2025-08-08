include "globals.mzn";

int: num_jobs;  % Number of jobs to be scheduled
int: num_machines;  % Number of machines available for job scheduling
array[1..num_jobs, 1..num_machines] of int: job_times;  % Time each job takes on each machine
array[1..num_jobs, 1..num_machines] of int: job_order;  % Order of jobs on each machine

array[1..num_jobs] of var 0..100: start;  % Start times for each job
array[1..num_jobs] of var int: duration;  % Duration for each job on the respective machine
array[1..num_jobs] of int: use = [1 | j in 1..num_jobs];  % Each job uses 1 unit of resource (machine)

% Define the duration based on job_times and job_order
% Each job's duration is determined by the time it takes on the machine it is assigned to
constraint forall(j in 1..num_jobs)(
    duration[j] = sum(i in 1..num_machines)(job_times[j, i] * (job_order[j, i] == 1))
);

int: cap = 1;  % Each machine can handle one job at a time
constraint cumulative(start, duration, use, cap);  % Ensure jobs do not overlap on machines

% Ensure jobs are processed in the correct order across machines
constraint forall(m in 1..num_machines)(
    forall(j in 1..num_jobs-1)(
        start[j+1] >= start[j] + duration[j] * (job_order[j, m] == 1)
    )
);

% Objective: Minimize the earliest end time
var int: end_time = max([start[j] + duration[j] | j in 1..num_jobs]);
solve minimize end_time;

output [ "End time = ", show(end_time), "\n", 
         "Start times = ", show(start), "\n", 
         "Durations = ", show(duration), "\n" ];