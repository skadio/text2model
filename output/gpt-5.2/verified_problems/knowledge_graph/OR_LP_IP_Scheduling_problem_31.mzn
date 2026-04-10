include "globals.mzn";

int: num_jobs;
int: num_machines;

array[1..num_jobs, 1..num_machines] of int: job_times;
array[1..num_jobs, 1..num_machines] of int: job_order; % machine index per operation (1..num_machines)

set of int: JOBS = 1..num_jobs;
set of int: OPS  = 1..num_machines;
set of int: MACH = 1..num_machines;

int: H = sum(j in JOBS, o in OPS)(job_times[j,o]);

array[JOBS, OPS] of var 0..H: start;
array[JOBS, OPS] of var 0..H: endt;

constraint
  forall(j in JOBS, o in OPS) (
    endt[j,o] = start[j,o] + job_times[j,o]
  );

% Precedence within each job (given operation sequence 1..num_machines)
constraint
  forall(j in JOBS, o in 1..num_machines-1) (
    start[j,o+1] >= endt[j,o]
  );

% Non-overlap on each machine among all operations assigned to that machine
constraint
  forall(m in MACH) (
    disjunctive(
      [ start[j,o] | j in JOBS, o in OPS where job_order[j,o] = m ],
      [ job_times[j,o] | j in JOBS, o in OPS where job_order[j,o] = m ]
    )
  );

var 0..H: makespan;
constraint makespan = max([endt[j,num_machines] | j in JOBS]);

solve minimize makespan;

output [
  "makespan=", show(makespan), "\n"
] ++
[
  "job ", show(j), ": " ++
  concat([ "op" ++ show(o) ++ "(m=" ++ show(job_order[j,o]) ++
           ",s=" ++ show(start[j,o]) ++
           ",e=" ++ show(endt[j,o]) ++ ") " | o in OPS ]) ++ "\n"
  | j in JOBS
];