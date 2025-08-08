int: num_jobs;
int: num_machines;

array[1..num_jobs, 1..num_machines] of int: job_times;
array[1..num_jobs, 1..num_machines] of int: job_order;

array[1..num_jobs, 1..num_machines] of var int: start;
array[1..num_jobs, 1..num_machines] of var int: end;

var int: makespan;

constraint
  forall(j in 1..num_jobs, m in 1..num_machines) (
    start[j,m] >= 0
  );

constraint
  forall(j in 1..num_jobs, m in 1..num_machines) (
    end[j,m] = start[j,m] + job_times[j,m]
  );

constraint
  forall(j in 1..num_jobs, m in 1..num_machines-1) (
    start[j,m+1] >= end[j,m]
  );

constraint
  forall(m in 1..num_machines, p in 1..num_jobs-1, q in p+1..num_jobs) (
    let {
      int: job_p = job_order[p,m];
      int: job_q = job_order[q,m];
    } in
      end[job_p,m] <= start[job_q,m]
  );

constraint
  makespan >= end[j,m] forall(j in 1..num_jobs, m in 1..num_machines);

solve minimize makespan;

output [
  "Makespan: ", show(makespan), "\n",
  "Start times:\n",
  concat([ "Job ", show(j), ": ", show([start[j,m] | m in 1..num_machines]), "\n" | j in 1..num_jobs ])
];