int: num_jobs;
int: num_machines;

array[1..num_jobs, 1..num_machines] of int: job_times;
array[1..num_jobs, 1..num_machines] of int: job_order;

set of int: JOBS = 1..num_jobs;
set of int: MACHINES = 1..num_machines;
set of int: OPS = 1..num_machines;

int: horizon = sum(j in JOBS, m in MACHINES)(job_times[j,m]);

array[JOBS, OPS] of var 0..horizon: start;
array[JOBS, OPS] of var 0..horizon: end;

constraint
  forall(j in JOBS, o in OPS) (
    end[j,o] = start[j,o] + job_times[j, job_order[j,o]]
  );

% Precedence constraints within each job (order given by job_order columns)
constraint
  forall(j in JOBS, o in 1..num_machines-1) (
    start[j,o+1] >= end[j,o]
  );

% No-overlap constraints on each machine using disjunctive constraints
constraint
  forall(m in MACHINES, j1 in JOBS, j2 in JOBS where j1 < j2) (
    let {
      int: o1 = min([o | o in OPS where job_order[j1,o] = m]),
      int: o2 = min([o | o in OPS where job_order[j2,o] = m])
    } in
      (end[j1,o1] <= start[j2,o2]) \/ (end[j2,o2] <= start[j1,o1])
  );

var 0..horizon: makespan;
constraint makespan = max([end[j,num_machines] | j in JOBS]);

solve minimize makespan;

output [
  "makespan = ", show(makespan), ";\n",
  "start = ", show(start), ";\n",
  "end = ", show(end), ";\n"
];