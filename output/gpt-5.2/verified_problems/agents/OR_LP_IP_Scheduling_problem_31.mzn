% Parameters
int: num_jobs;                          % Number of jobs
int: num_machines;                      % Number of machines

set of int: JOBS = 1..num_jobs;         % Job index set
set of int: MACHINES = 1..num_machines; % Machine index set

array[JOBS, MACHINES] of int: job_times; % Processing time of job j on machine m
array[JOBS, MACHINES] of int: job_order; % For job j, the k-th operation runs on machine job_order[j,k]

% Variables
int: horizon = sum(j in JOBS, m in MACHINES)(job_times[j,m]); % Simple upper bound on makespan

array[JOBS, MACHINES] of var 0..horizon: start_time; % Start time of job j on machine m
array[JOBS, MACHINES] of var 0..horizon: end_time;   % End time of job j on machine m

var 0..horizon: makespan;                             % Overall completion time (to minimize)

% Constraints

% --- Processing time linkage: end_time = start_time + duration ---
constraint
  forall(j in JOBS, m in MACHINES) (
    end_time[j,m] = start_time[j,m] + job_times[j,m]
  );

% --- Technological order within each job (follow the given machine sequence) ---
% job_order[j,k] gives the machine for the k-th operation of job j.
constraint
  forall(j in JOBS, k in 1..num_machines-1) (
    start_time[j, job_order[j,k+1]] >= end_time[j, job_order[j,k]]
  );

% --- Capacity constraints: no overlap of operations on the same machine ---
constraint
  forall(m in MACHINES) (
    disjunctive(
      [ start_time[j,m] | j in JOBS ],
      [ job_times[j,m]  | j in JOBS ]
    )
  );

% --- Makespan definition: must be at least the end time of every operation ---
constraint
  forall(j in JOBS, m in MACHINES) (
    makespan >= end_time[j,m]
  );

% Objective
solve minimize makespan;