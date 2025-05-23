int: num_jobs;
int: num_machines;

array[1..num_jobs, 1..num_machines] of int: job_times;
array[1..num_jobs, 1..num_machines] of int: job_order;

% Upper bound on the schedule length (provided in the data file)
int: max_time;
int: UB = max_time;

array[1..num_jobs, 1..num_machines] of var 0..UB: start_time;
array[1..num_jobs, 1..num_machines] of var 0..UB: end_time;
var 0..UB: makespan;

% Duration relationship
constraint
  forall(j in 1..num_jobs, s in 1..num_machines)(
    end_time[j,s] = start_time[j,s] + job_times[j,s]
  );

% Technological order inside each job
constraint
  forall(j in 1..num_jobs, s in 1..num_machines-1)(
    start_time[j,s+1] >= end_time[j,s]
  );

% Machine capacity (no overlap on the same machine)
constraint
  forall(m in 1..num_machines)(
    forall(j1 in 1..num_jobs, j2 in j1+1..num_jobs)(
      let {
        set of int: S1 = { s | s in 1..num_machines where job_order[j1,s] = m },
        set of int: S2 = { s | s in 1..num_machines where job_order[j2,s] = m }
      } in
      forall(s1 in S1, s2 in S2)(
        end_time[j1,s1] <= start_time[j2,s2] \/
        end_time[j2,s2] <= start_time[j1,s1]
      )
    )
  );

% Makespan definition
constraint
  forall(j in 1..num_jobs, s in 1..num_machines)(
    end_time[j,s] <= makespan
  );

solve minimize makespan;