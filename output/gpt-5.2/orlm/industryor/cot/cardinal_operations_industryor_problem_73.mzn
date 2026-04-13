% Parameters (with values embedded)
int: n = 7;
set of int: Activities = 1..n;

int: A = 1;
int: B = 2;
int: C = 3;
int: D = 4;
int: E = 5;
int: F = 6;
int: G = 7;

array[Activities] of int: dur = [4, 3, 5, 2, 10, 10, 1];

int: work_cost_per_day = 1000;
int: machine_cost_per_day = 5000;

% precedence arcs (i -> j)
int: m = 7;
array[1..m] of int: pred = [A, A, E, G, D, F, F];
array[1..m] of int: succ = [G, D, F, F, C, C, B];

% Upper bound for start times (simple horizon bound)
int: H = sum(i in Activities)(dur[i]);  % 35

% Variables
array[Activities] of var 0..H: s;            % start time of each activity
var 0..H: project_end;                       % makespan (end of last activity)

% machine rental: from start of A to end of B
var 0..H: machine_start;
var 0..(H + max(i in Activities)(dur[i])): machine_end;
var 0..(H + max(i in Activities)(dur[i])): machine_days;

var int: total_cost;

% Constraints
% Precedence constraints: s[succ] >= s[pred] + dur[pred]
constraint
  forall(k in 1..m)(
    s[succ[k]] >= s[pred[k]] + dur[pred[k]]
  );

% Project end after all activities
constraint
  forall(i in Activities)(
    project_end >= s[i] + dur[i]
  );

% Machine rental interval: start of A to end of B
constraint machine_start = s[A];
constraint machine_end   = s[B] + dur[B];
constraint machine_days  = machine_end - machine_start;

% Cost definition:
% Work cost is proportional to total activity-days (constant), plus machine rental cost per day.
constraint
  total_cost =
    work_cost_per_day * sum(i in Activities)(dur[i])
    + machine_cost_per_day * machine_days;

% Objective
solve minimize total_cost;

output [
  "Start times (days):\n",
  "A=", show(s[A]), " B=", show(s[B]), " C=", show(s[C]), " D=", show(s[D]),
  " E=", show(s[E]), " F=", show(s[F]), " G=", show(s[G]), "\n",
  "Project end=", show(project_end), "\n",
  "Machine rental: start=", show(machine_start), " end=", show(machine_end),
  " days=", show(machine_days), "\n",
  "Total cost (EUR)=", show(total_cost), "\n"
];