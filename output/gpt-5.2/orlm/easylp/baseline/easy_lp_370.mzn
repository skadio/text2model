int: H = 24;

set of int: TASKS = 1..4;
array[TASKS] of int: workload = [1,2,3,4];

array[TASKS] of var 0..H: start;

% Constraints
constraint start[1] >= 5;
constraint abs(start[2] - start[1]) <= 8;
constraint abs(start[3] - start[2]) >= 10;
constraint abs(start[4] - start[3]) <= 15;

% Objective: minimize total workload (constant w.r.t. start times)
var int: total_workload = sum(t in TASKS)(workload[t]);
solve minimize total_workload;

output [
  "total_workload=", show(total_workload), "\n",
  "start_t1=", show(start[1]), "\n",
  "start_t2=", show(start[2]), "\n",
  "start_t3=", show(start[3]), "\n",
  "start_t4=", show(start[4]), "\n"
];