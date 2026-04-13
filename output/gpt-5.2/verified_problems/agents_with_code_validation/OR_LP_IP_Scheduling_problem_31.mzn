% Parameters
int: num_jobs;                            % Number of jobs
int: num_machines;                        % Number of machines

set of int: JOBS = 1..num_jobs;
set of int: MACHINES = 1..num_machines;

array[JOBS, MACHINES] of int: job_times;  % Processing time of job j on machine m
array[JOBS, MACHINES] of int: job_order;  % Sequence position of machine m for job j (1..num_machines)

% Some datasets use `max_time` as the horizon. Accept it if provided; otherwise use sum of times.
int: horizon_default = sum(j in JOBS, m in MACHINES)(job_times[j, m]);
int: max_time = if is_defined_var("max_time") then max_time else horizon_default endif;

var 0..max_time: makespan;

array[JOBS, MACHINES] of var 0..max_time: start_time;
array[JOBS, MACHINES] of var 0..max_time: end_time;

% Link start/end times via processing durations
constraint
  forall(j in JOBS, m in MACHINES) (
    end_time[j, m] = start_time[j, m] + job_times[j, m]
  );

% Technological precedence constraints within each job (follow job_order)
constraint
  forall(j in JOBS, m1 in MACHINES, m2 in MACHINES
         where job_order[j, m2] = job_order[j, m1] + 1) (
    start_time[j, m2] >= end_time[j, m1]
  );

% Machine capacity constraints: no overlap on the same machine
constraint
  forall(m in MACHINES, j1 in JOBS, j2 in JOBS where j1 < j2) (
    let { var bool: j1_before_j2 } in
      (j1_before_j2 -> end_time[j1, m] <= start_time[j2, m]) /\
      (not j1_before_j2 -> end_time[j2, m] <= start_time[j1, m])
  );

% Makespan is at least the completion time of every operation
constraint
  forall(j in JOBS, m in MACHINES) (
    makespan >= end_time[j, m]
  );

solve minimize makespan;