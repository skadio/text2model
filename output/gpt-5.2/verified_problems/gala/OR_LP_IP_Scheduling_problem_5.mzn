include "globals.mzn";

int: rows; % number of programmers
int: cols; % number of jobs

array[1..rows, 1..cols] of int: cost; % preference values (1 = best)

/* Decision variables:
   job_of_programmer[p] = job assigned to programmer p */
array[1..rows] of var 1..cols: job_of_programmer;

/* Optional binary assignment matrix (derived) */
array[1..rows, 1..cols] of var 0..1: x;

/* Each programmer gets exactly one job (implicit by job_of_programmer domain) */
constraint all_different(job_of_programmer); % each job assigned to at most one programmer

/* Link x to job_of_programmer */
constraint forall(p in 1..rows, j in 1..cols) (
  x[p,j] = bool2int(job_of_programmer[p] = j)
);

/* If square (rows=cols), then this is a perfect assignment. If not, enforce feasibility:
   - If more programmers than jobs, impossible under all_different; let solver report UNSAT.
   - If fewer programmers than jobs, some jobs remain unassigned, which is allowed. */

/* Objective: minimize total preference cost */
var int: total_cost =
  sum(p in 1..rows)( cost[p, job_of_programmer[p]] );

solve minimize total_cost;

output [
  "total_cost = ", show(total_cost), "\n",
  "job_of_programmer = ", show(job_of_programmer), "\n",
  "x = array2d(1..rows, 1..cols, ", show([x[p,j] | p in 1..rows, j in 1..cols]), ")\n"
];