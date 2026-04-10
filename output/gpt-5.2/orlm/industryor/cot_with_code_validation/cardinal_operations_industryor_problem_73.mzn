% Parameters
int: N = 7;
set of int: ACT = 1..N;

int: A = 1;
int: B = 2;
int: C = 3;
int: D = 4;
int: E = 5;
int: F = 6;
int: G = 7;

array[ACT] of int: dur = [4, 3, 5, 2, 10, 10, 1];

int: work_cost_per_day = 1000;
int: machine_cost_per_day = 5000;

% Precedence arcs (i -> j means start[j] >= end[i])
int: P = 8;
set of int: ARC = 1..P;
array[ARC] of int: pred = [A, A, E, G, D, F, F, D];
array[ARC] of int: succ = [G, D, F, F, C, C, B, C];

% Makespan upper bound (sum of all durations)
int: H = sum(i in ACT)(dur[i]);

% Variables
array[ACT] of var 0..H: s;                 % start times
array[ACT] of var 0..H: e;                 % end times
var 0..H: project_end;                     % project completion time
var 0..H: machine_span;                    % from start(A) to end(B)
var 0..(work_cost_per_day*H + machine_cost_per_day*H): total_cost;

% Constraints
constraint forall(i in ACT) (
  e[i] = s[i] + dur[i]
);

constraint forall(k in ARC) (
  s[succ[k]] >= e[pred[k]]
);

constraint project_end >= max(i in ACT)(e[i]);

constraint machine_span = e[B] - s[A];
constraint machine_span >= 0;

constraint total_cost =
  work_cost_per_day * project_end + machine_cost_per_day * machine_span;

% Objective
solve minimize total_cost;