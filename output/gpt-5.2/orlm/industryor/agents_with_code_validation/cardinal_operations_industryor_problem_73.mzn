% Parameters
int: nActivities = 7;                         % Number of activities
set of int: ACTIVITIES = 1..nActivities;      % Activity index set

% Activity name mapping (for readability)
int: A = 1;
int: B = 2;
int: C = 3;
int: D = 4;
int: E = 5;
int: F = 6;
int: G = 7;

array[ACTIVITIES] of int: duration =          % Duration (days) of each activity
  [ 4, 3, 5, 2, 10, 10, 1 ];

% Precedence arcs (pred -> succ)
int: nPrec = 7;
set of int: PRECS = 1..nPrec;
array[PRECS] of int: pred = [ A, A, E, G, D, F, F ];
array[PRECS] of int: succ = [ G, D, F, F, C, C, B ];

% Costs
int: cost_work_per_day = 1000;                % Euros/day for work (project duration based)
int: cost_machine_per_day = 5000;             % Euros/day for machine rental (A start to B end)

% Time horizon upper bound (safe bound for start/end times)
int: H = sum(i in ACTIVITIES)(duration[i]);   % Sum of all durations (max possible makespan)


% Variables
array[ACTIVITIES] of var 0..H: start;           % Start time (day) of each activity
array[ACTIVITIES] of var 0..H: finish;          % Finish time (day) of each activity

var 0..H: project_end;                          % End time of the project (makespan)
var 0..H: machine_start;                        % Start of machine rental (coincides with start[A])
var 0..H: machine_end;                          % End of machine rental (coincides with finish[B])
var 0..H: machine_rental_duration;              % Duration of machine rental

var 0..(cost_work_per_day * H): work_cost;       % Total work cost component
var 0..(cost_machine_per_day * H): machine_cost; % Total machine cost component
var 0..((cost_work_per_day + cost_machine_per_day) * H): total_cost; % Objective value


% Constraints

%------------------------------------------------------------
% Activity timing: finish time equals start + duration
%------------------------------------------------------------
constraint
  forall(i in ACTIVITIES) (
    finish[i] = start[i] + duration[i]
  );

%------------------------------------------------------------
% Precedence constraints: successor cannot start before predecessor finishes
%------------------------------------------------------------
constraint
  forall(p in PRECS) (
    start[succ[p]] >= finish[pred[p]]
  );

%------------------------------------------------------------
% Project makespan: project_end is the maximum of all finish times
%------------------------------------------------------------
constraint
  project_end = max(i in ACTIVITIES)(finish[i]);

%------------------------------------------------------------
% Machine rental window: from start of A to end of B
%------------------------------------------------------------
constraint machine_start = start[A];
constraint machine_end   = finish[B];

% Machine rental duration (nonnegative and consistent)
constraint machine_rental_duration = machine_end - machine_start;

%------------------------------------------------------------
% Cost definitions (linear)
% Work cost is proportional to project duration (as specified)
%------------------------------------------------------------
constraint work_cost = cost_work_per_day * project_end;

% Machine cost is proportional to the rental duration
constraint machine_cost = cost_machine_per_day * machine_rental_duration;

% Total cost aggregation
constraint total_cost = work_cost + machine_cost;


% Objective
solve minimize total_cost;