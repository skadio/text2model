int: num_jobs;
int: num_machines;

array[1..num_jobs, 1..num_machines] of int: job_times;
array[1..num_jobs, 1..num_machines] of int: job_order;

int: H = sum(j in 1..num_jobs, m in 1..num_machines)(job_times[j,m]);

array[1..num_jobs, 1..num_machines] of var 0..H: start;
array[1..num_jobs] of var 0..H: end_job;
var 0..H: makespan;

constraint forall(j in 1..num_jobs, m in 1..num_machines) (job_times[j,m] >= 0);
constraint forall(j in 1..num_jobs, k in 1..num_machines) (job_order[j,k] >= 1 /\ job_order[j,k] <= num_machines);
constraint forall(j in 1..num_jobs) (alldifferent([job_order[j,k] | k in 1..num_machines]));

constraint
  forall(j in 1..num_jobs, k in 1..num_machines - 1) (
    let {
      int: m1 = job_order[j,k];
      int: m2 = job_order[j,k+1];
    } in
      start[j,m2] >= start[j,m1] + job_times[j,m1]
  );

constraint
  forall(m in 1..num_machines, j1 in 1..num_jobs, j2 in j1+1..num_jobs) (
    (start[j1,m] + job_times[j1,m] <= start[j2,m]) \/
    (start[j2,m] + job_times[j2,m] <= start[j1,m])
  );

constraint
  forall(j in 1..num_jobs) (
    let {
      int: last_m = job_order[j,num_machines];
    } in
      end_job[j] = start[j,last_m] + job_times[j,last_m]
  );

constraint makespan = max([end_job[j] | j in 1..num_jobs]);

solve minimize makespan;