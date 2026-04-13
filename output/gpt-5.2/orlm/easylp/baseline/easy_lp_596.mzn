% Fleet allocation cost minimization (all data embedded)

int: n = 4;
set of int: T = 1..n;

array[T] of int: avail = [700, 500, 600, 800];
array[T] of int: cost  = [50, 60, 70, 80];

int: max_op1 = 1000; % x1 + x2
int: max_op2 = 1200; % x3 + x4
int: min_heavy = 800; % x1 + x3
int: min_req   = 600; % x2 + x4

array[T] of var 0..avail[T]: x;

constraint x[1] + x[2] <= max_op1;
constraint x[3] + x[4] <= max_op2;
constraint x[1] + x[3] >= min_heavy;
constraint x[2] + x[4] >= min_req;

var int: total_cost = sum(t in T)(cost[t] * x[t]);

solve minimize total_cost;

output [
  "x1=", show(x[1]), " x2=", show(x[2]), " x3=", show(x[3]), " x4=", show(x[4]), "\n",
  "min_daily_cost=$", show(total_cost), "\n"
];