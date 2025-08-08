%  ---------------------------------------------------------------
%  Job‑Shop Scheduling – MiniZinc model
%  ---------------------------------------------------------------
include "globals.mzn";

% ---------- DATA (to be supplied in a .dzn file) ----------
int: num_jobs;
int: num_machines;
array[1..num_jobs,1..num_machines] of int: job_times;
array[1..num_jobs,1..num_machines] of int: job_order;   % order position of job i on machine m

% ---------- PARAMETERS ----------
int: max_time = sum([ job_times[i,m] | i in 1..num_jobs, m in 1..num_machines ]);

% ---------- VARIABLES ----------
array[1..num_jobs,1..num_machines] of var 0..max_time: start;     % start time of operation (i,m)

array[1..num_machines] of int: cap = [1 | m in 1..num_machines];  % machine capacity
array[1..num_machines] of int: use = [1 | m in 1..num_machines];  % one job at a time

var 0..max_time: makespan;  % overall finishing time

% ---------- CONSTRAINTS ----------

% 1. Machine availability – cumulative
constraint forall(m in 1..num_machines) (
    let {
        array[1..num_jobs] of var int: start_m = [start[i,m] | i in 1..num_jobs];
        array[1..num_jobs] of int:      dur_m   = [job_times[i,m] | i in 1..num_jobs];
    } in
        cumulative(start_m, dur_m, use, cap[m])
);

% 2. Each machine has a unique order for the jobs that visit it
constraint forall(m in 1..num_machines)(
    all_different([ job_order[i,m] | i in 1..num_jobs ])
);

% 3. Precedence constraints – order of machines for each job
constraint forall(i in 1..num_jobs,
                 m1 in 1..num_machines,
                 m2 in 1..num_machines where m1 != m2) (
    let {
        int: o1 = job_order[i,m1];
        int: o2 = job_order[i,m2];
    } in
        (o1 + 1 == o2) ->
            start[i,m2] >= start[i,m1] + job_times[i,m1]
);

% 4. Makespan definition
constraint makespan >= start[i,m] + job_times[i,m]
    forall(i in 1..num_jobs, m in 1..num_machines);

% 5. (Optional) Lower bound for start times
constraint forall(i in 1..num_jobs, m in 1..num_machines)(
    start[i,m] >= 0
);

% ---------- SOLVE ----------
solve minimize makespan;

% ---------- OUTPUT ----------
output [
    "Start times (job × machine):\n",
    show(start),
    "\nMakespan = ", show(makespan), "\n"
];