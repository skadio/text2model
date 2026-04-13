include "globals.mzn";

% Planning horizon: one day (hours 0..23)
int: H = 24;

% Workloads (fixed by problem statement)
int: w1 = 1;
int: w2 = 2;
int: w3 = 3;
int: w4 = 4;

% Decision variables: integer start times (hours)
var 0..H-1: t1;
var 0..H-1: t2;
var 0..H-1: t3;
var 0..H-1: t4;

% Constraints
constraint t1 >= 5;
constraint abs(t2 - t1) <= 8;
constraint abs(t3 - t2) >= 10;
constraint abs(t4 - t3) <= 15;

% Objective: total workload of the tasks (constant, but kept as requested)
var int: total_workload = w1 + w2 + w3 + w4;

solve minimize total_workload;

output [
  "t1=", show(t1), " t2=", show(t2), " t3=", show(t3), " t4=", show(t4), "\n",
  "minimum_total_workload=", show(total_workload), "\n"
];