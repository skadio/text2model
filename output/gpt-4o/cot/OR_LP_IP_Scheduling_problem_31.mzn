% Parameters
int: num_jobs;
int: num_machines;

set of int: JOBS     = 1..num_jobs;
set of int: MACHINES = 1..num_machines;
set of int: OPS      = 1..num_machines;   % operation index within a job (1st, 2nd, ...)

array[JOBS, OPS] of int: job_times;        % processing times
array[JOBS, OPS] of int: job_order;        % machine used by each operation

int: horizon = sum(j in JOBS, o in OPS)(job_times[j,o]);   % upper bound on the schedule length


% Variables
array[JOBS, OPS] of var 0..horizon: start;   % start time of every operation
var 0..horizon: makespan;                    % length of the schedule


% Constraints
% 1. Technology (within-job) precedence
constraint
  forall(j in JOBS, o in 1..num_machines-1) (
    start[j,o+1] >= start[j,o] + job_times[j,o]
  );

% 2. Machine capacity – no overlapping operations on the same machine
constraint
  forall(m in MACHINES)(
    forall(j1 in JOBS, j2 in JOBS where j1 < j2,
           o1 in OPS, o2 in OPS
           where job_order[j1,o1] == m /\ job_order[j2,o2] == m)(
      (start[j1,o1] + job_times[j1,o1] <= start[j2,o2]) \/
      (start[j2,o2] + job_times[j2,o2] <= start[j1,o1])
    )
  );

% 3. Definition of the makespan
constraint
  forall(j in JOBS)(
    makespan >= start[j,num_machines] + job_times[j,num_machines]
  );


% Objective
solve minimize makespan;