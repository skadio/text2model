% Flow shop scheduling: 5 batches (jobs) through 3 vats (machines) in order.
% Objective: minimize makespan (completion time of last batch on vat 3).

int: nJobs = 5;
int: nMachs = 3;

set of int: JOBS = 1..nJobs;
set of int: MACHS = 1..nMachs;

% Use integer time units = tenths of an hour to avoid floats.
array[JOBS, MACHS] of int: p = array2d(JOBS, MACHS, [
  30, 10, 10,
  20, 15, 10,
  30, 12, 13,
  20, 20, 20,
  21, 20, 30
]);

int: UB = sum(j in JOBS, m in MACHS)(p[j,m]);

array[JOBS, MACHS] of var 0..UB: s; % start times (tenths of an hour)
array[JOBS, MACHS] of var 0..UB: c; % completion times

% Technological order within each job (vat 1 -> vat 2 -> vat 3)
constraint forall(j in JOBS, m in 1..nMachs-1) (
  s[j,m+1] >= c[j,m]
);

% Define completion times
constraint forall(j in JOBS, m in MACHS) (
  c[j,m] = s[j,m] + p[j,m]
);

% No overlap on each machine: for any two different jobs, order them on each vat
array[MACHS, JOBS, JOBS] of var bool: before; % before[m,i,k] = job i before job k on machine m

constraint forall(m in MACHS, i in JOBS, k in JOBS where i < k) (
  (before[m,i,k] /\ s[i,m] + p[i,m] <= s[k,m]) \/
  ((not before[m,i,k]) /\ s[k,m] + p[k,m] <= s[i,m])
);

var 0..UB: makespan;
constraint makespan = max(j in JOBS)(c[j,nMachs]);

solve minimize makespan;

% Output (convert tenths of an hour back to hours)
function string: fmt_time(var int: t) =
  let { var int: h = t div 10, var int: d = t mod 10 } in
  show(h) ++ "." ++ show(d);

output [
  "Makespan (hours): ", fmt_time(makespan), "\n\n"
] ++
[
  "Job ", show(j), ": " ++
  concat([ "Vat" ++ show(m) ++ " [" ++ fmt_time(s[j,m]) ++ "," ++ fmt_time(c[j,m]) ++ "] " | m in MACHS ])
  ++ "\n"
  | j in JOBS
];