int: num_jobs;
int: num_machines;

array[1..num_jobs, 1..num_machines] of int: job_times;
array[1..num_jobs, 1..num_machines] of int: job_order;

int: horizon = sum(j in 1..num_jobs, m in 1..num_machines)(job_times[j,m]);

array[1..num_jobs, 1..num_machines] of var 0..horizon: start;
array[1..num_jobs, 1..num_machines] of var 0..horizon: finish;

var 0..horizon: makespan;

constraint
  forall(j in 1..num_jobs, m in 1..num_machines) (
    finish[j,m] = start[j,m] + job_times[j,m]
  );

constraint
  forall(j in 1..num_jobs, k in 1..num_machines - 1) (
    finish[j, job_order[j,k]] <= start[j, job_order[j,k+1]]
  );

constraint
  forall(m in 1..num_machines, j1 in 1..num_jobs, j2 in j1 + 1..num_jobs) (
    (finish[j1,m] <= start[j2,m]) \/ (finish[j2,m] <= start[j1,m])
  );

constraint
  forall(j in 1..num_jobs, m in 1..num_machines) (
    makespan >= finish[j,m]
  );

solve minimize makespan;