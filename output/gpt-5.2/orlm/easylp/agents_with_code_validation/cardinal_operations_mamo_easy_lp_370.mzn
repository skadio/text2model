% Parameters
int: nTasks = 4;                                  % number of tasks
set of int: TASKS = 1..nTasks;                    % task index set: 1=t1, 2=t2, 3=t3, 4=t4

int: horizon = 24;                                % hours in a day
array[TASKS] of int: workload = [1, 2, 3, 4];      % workload per task (t1..t4)

int: t1_min_start = 5;                            % t1 must start at least at hour 5
int: max_diff_t2_t1 = 8;                          % |start(t2)-start(t1)| <= 8
int: min_diff_t3_t2 = 10;                         % start(t3)-start(t2) >= 10
int: max_diff_t4_t3 = 15;                         % |start(t4)-start(t3)| <= 15

% Variables
array[TASKS] of var 0..horizon: start;            % integer start hour for each task within the day
var int: total_workload;                          % objective value (sum of workloads)

% Constraints
% Start-time domain within the single-day horizon (redundant but clarifies intent)
constraint
  forall(t in TASKS) (
    start[t] >= 0 /\ start[t] <= horizon
  );

% Task t1 earliest start requirement
constraint
  start[1] >= t1_min_start;

% Dependency/time-distance between t2 and t1: |start(t2) - start(t1)| <= 8
constraint
  abs(start[2] - start[1]) <= max_diff_t2_t1;

% Dependency/time-distance between t3 and t2: start(t3) - start(t2) >= 10
constraint
  start[3] - start[2] >= min_diff_t3_t2;

% Dependency/time-distance between t4 and t3: |start(t4) - start(t3)| <= 15
constraint
  abs(start[4] - start[3]) <= max_diff_t4_t3;

% Total workload definition (objective value variable)
constraint
  total_workload = sum(t in TASKS)(workload[t]);

% Objective
solve minimize total_workload;