% Flow shop scheduling: 3 jobs, 3 machines, same job order on all machines.
% Minimize makespan (total processing cycle).

include "globals.mzn";

int: nJobs = 3;
int: nMach = 3;

set of int: Jobs = 1..nJobs;
set of int: Mach = 1..nMach;
set of int: Pos  = 1..nJobs;

array[Jobs, Mach] of int: t =
  array2d(Jobs, Mach,
    [ 2,3,1,   % job 1
      4,2,3,   % job 2
      3,5,2    % job 3
    ]);

% Permutation: jobAtPos[p] is the job scheduled at position p (same for all machines)
array[Pos] of var Jobs: jobAtPos;
constraint all_different(jobAtPos);

% Start times per position and machine
array[Pos, Mach] of var int: start;
array[Pos, Mach] of var int: end;

constraint forall(p in Pos, m in Mach) (
  start[p,m] >= 0 /\
  end[p,m] = start[p,m] + t[jobAtPos[p], m]
);

% No overlap on each machine (same order across machines, positions are consecutive)
constraint forall(m in Mach, p in 2..nJobs) (
  start[p,m] >= end[p-1,m]
);

% Job flow: within same job (position), machine m+1 starts after machine m ends
constraint forall(p in Pos, m in 1..nMach-1) (
  start[p,m+1] >= end[p,m]
);

var int: makespan = end[nJobs, nMach];

solve minimize makespan;

output [
  "Job order (positions 1..", show(nJobs), "): ", show(jobAtPos), "\n",
  "Makespan: ", show(makespan), "\n\n",
  "Start/End times by position and machine:\n"
] ++
[
  "Pos " ++ show(p) ++ " (Job " ++ show(jobAtPos[p]) ++ "): " ++
  concat([ "M" ++ show(m) ++ "[" ++ show(start[p,m]) ++ "," ++ show(end[p,m]) ++ "] " | m in Mach ]) ++ "\n"
  | p in Pos
];