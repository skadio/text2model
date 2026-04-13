% Parameters
int: n = 7;
set of int: ACTIVITIES = 1..n;

int: A = 1;
int: B = 2;
int: C = 3;
int: D = 4;
int: E = 5;
int: F = 6;
int: G = 7;

array[ACTIVITIES] of int: dur = [4, 3, 5, 2, 10, 10, 1];

int: work_cost_per_day = 1000;
int: machine_cost_per_day = 5000;

% precedence arcs (i -> j)
int: m = 7;
set of int: ARCS = 1..m;
array[ARCS] of int: pred = [A, A, E, G, D, F, F];
array[ARCS] of int: succ = [G, D, F, F, C, C, B];

int: dur_sum = sum(i in ACTIVITIES)(dur[i]);

% Variables
array[ACTIVITIES] of var 0..dur_sum: s;  % start times
array[ACTIVITIES] of var 0..dur_sum: e;  % end times
var 0..dur_sum: project_makespan;

% machine rental interval: from start of A to end of B
var 0..dur_sum: machine_start;
var 0..dur_sum: machine_end;
var 0..dur_sum: machine_duration;

var 0..(work_cost_per_day * dur_sum + machine_cost_per_day * dur_sum): total_cost;

% Constraints
constraint forall(i in ACTIVITIES) (
  e[i] = s[i] + dur[i]
);

constraint forall(k in ARCS) (
  s[succ[k]] >= e[pred[k]]
);

constraint project_makespan = max(i in ACTIVITIES)(e[i]);

constraint machine_start = s[A];
constraint machine_end = e[B];
constraint machine_duration = machine_end - machine_start;
constraint machine_duration >= 0;

constraint total_cost =
  work_cost_per_day * sum(i in ACTIVITIES)(dur[i]) +
  machine_cost_per_day * machine_duration;

% Objective
solve minimize total_cost;