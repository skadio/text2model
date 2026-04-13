% Parameters
int: nTasks = 4;                               % number of tasks
set of int: TASKS = 1..nTasks;                 % task index set {1=t1,2=t2,3=t3,4=t4}

int: horizon = 24;                             % single-day horizon in hours
array[TASKS] of int: workload = [1, 2, 3, 4];   % workloads for t1..t4

int: t1_min_start = 5;                         % t1 must start at least at hour 5
int: t2_t1_max_diff = 8;                       % |start(t2) - start(t1)| <= 8
int: t3_t2_min_diff = 10;                      % start(t3) - start(t2) >= 10
int: t4_t3_max_diff = 15;                      % |start(t4) - start(t3)| <= 15

% Variables
array[TASKS] of var 0..horizon: start;         % integer start time (hour) for each task within the day
var int: total_workload;                       % total workload objective value (constant w.r.t schedule)

% Constraints

% --- Total workload definition (sum of fixed workloads) ---
constraint
  total_workload = sum(t in TASKS)(workload[t]);

% --- Task t1 minimum start time ---
constraint
  start[1] >= t1_min_start;

% --- Max absolute difference between starts of t2 and t1 ---
constraint
  abs(start[2] - start[1]) <= t2_t1_max_diff;

% --- Minimum difference between starts of t3 and t2 (t3 at least 10 hours after t2) ---
constraint
  start[3] - start[2] >= t3_t2_min_diff;

% --- Max absolute difference between starts of t4 and t3 ---
constraint
  abs(start[4] - start[3]) <= t4_t3_max_diff;

% Objective
solve minimize total_workload;