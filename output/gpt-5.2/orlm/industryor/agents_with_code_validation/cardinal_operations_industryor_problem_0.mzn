% Factory workforce + production planning with training, overtime, and backlog penalties
% Fixed to avoid timeout by tightening domains, using integers for penalties (scaled),
% and adding redundant but strong constraints to improve propagation.

%%%%%%%%%%%%
% Parameters
%%%%%%%%%%%%
int: W = 8;
set of int: Weeks = 1..W;

int: initial_skilled = 50;
int: target_new_trained = 50;

int: hours_normal = 40;
int: hours_overtime = 60;

int: rate_I_per_hour = 10;  % kg/h
int: rate_II_per_hour = 6;  % kg/h

int: train_duration = 2;    % weeks
int: trainees_per_trainer = 3;

int: wage_skilled_normal = 360;
int: wage_skilled_overtime = 540;
int: wage_trainee = 120;
int: wage_new = 240;

% Use scaled integer penalties to keep model purely integer and faster.
int: PEN_SCALE = 10;                 % 0.1 yuan units
int: pen_I = 5;                      % 0.5 yuan/kg/week
int: pen_II = 6;                     % 0.6 yuan/kg/week

array[Weeks] of int: demand_I =
  [10000, 10000, 12000, 12000, 16000, 16000, 20000, 20000];
array[Weeks] of int: demand_II =
  [ 6000,  7200,  8400, 10800, 10800, 12000, 12000, 12000];

% Maximum possible productive workers in any week
int: max_workforce = initial_skilled + target_new_trained; % 100

% Upper bound on total hours in any week
int: max_total_hours = max_workforce * hours_overtime; % 6000

% Backlog bounds (sum of demands is a safe upper bound)
int: max_backlog_I = sum(w in Weeks)(demand_I[w]);
int: max_backlog_II = sum(w in Weeks)(demand_II[w]);

%%%%%%%%%%%%
% Decisions
%%%%%%%%%%%%
% Training starts (week w starts a 2-week training block covering weeks w and w+1)
array[Weeks] of var 0..initial_skilled: trainers_start;
array[Weeks] of var 0..target_new_trained: trainees_start;

% State variables
array[Weeks] of var 0..target_new_trained: in_training;          % trainees currently in training
array[Weeks] of var 0..initial_skilled: available_skilled;       % skilled available for production
array[Weeks] of var 0..target_new_trained: available_new;        % trained new workers available for production

% Overtime assigned among production-capable workers
array[Weeks] of var 0..max_workforce: overtime_workers;

% Production hours split
array[Weeks] of var 0..max_total_hours: hours_I;
array[Weeks] of var 0..max_total_hours: hours_II;

% Backlogs (delayed deliveries)
array[0..W] of var 0..max_backlog_I: backlog_I;
array[0..W] of var 0..max_backlog_II: backlog_II;

% Derived production (defined via constraints; kept as var for clarity/propagation)
array[Weeks] of var 0..(max_total_hours * rate_I_per_hour): prod_I;
array[Weeks] of var 0..(max_total_hours * rate_II_per_hour): prod_II;

%%%%%%%%%%%%
% Constraints
%%%%%%%%%%%%

% Initial backlogs
constraint backlog_I[0] = 0;
constraint backlog_II[0] = 0;

% Training feasibility
constraint forall(w in Weeks) (
  trainees_start[w] <= trainees_per_trainer * trainers_start[w]
);

% No training can start in week 8 (needs 2 weeks)
constraint trainees_start[W] = 0;
constraint trainers_start[W] = 0;

% All 50 trainees must start training within horizon
constraint sum(w in Weeks)(trainees_start[w]) = target_new_trained;

% In-training headcount is a rolling 2-week window of starts
constraint forall(w in Weeks) (
  in_training[w] =
    trainees_start[w] +
    (if w > 1 then trainees_start[w-1] else 0 endif)
);

% Skilled available for production: initial minus trainers currently in training
constraint forall(w in Weeks) (
  available_skilled[w] =
    initial_skilled
    - trainers_start[w]
    - (if w > 1 then trainers_start[w-1] else 0 endif)
);

% New workers available for production: those whose training finished before week w
constraint forall(w in Weeks) (
  available_new[w] =
    (if w > train_duration then sum(t in 1..(w-train_duration))(trainees_start[t]) else 0 endif)
);

% Overtime bounded by available productive workers
constraint forall(w in Weeks) (
  overtime_workers[w] <= available_skilled[w] + available_new[w]
);

% Total labor hours available
constraint forall(w in Weeks) (
  hours_I[w] + hours_II[w]
  <= hours_normal * (available_skilled[w] + available_new[w])
     + (hours_overtime - hours_normal) * overtime_workers[w]
);

% Production from hours
constraint forall(w in Weeks) (
  prod_I[w] = rate_I_per_hour * hours_I[w]
);
constraint forall(w in Weeks) (
  prod_II[w] = rate_II_per_hour * hours_II[w]
);

% Backlog dynamics: backlog[w] = backlog[w-1] + demand[w] - production[w]
constraint forall(w in Weeks) (
  backlog_I[w] = backlog_I[w-1] + demand_I[w] - prod_I[w]
);
constraint forall(w in Weeks) (
  backlog_II[w] = backlog_II[w-1] + demand_II[w] - prod_II[w]
);

% All demand must be delivered by end of week 8
constraint backlog_I[W] = 0;
constraint backlog_II[W] = 0;

% Redundant tightening: weekly production cannot exceed (current backlog + demand)
% (Since ending backlog must be nonnegative.)
constraint forall(w in Weeks) (
  prod_I[w] <= backlog_I[w-1] + demand_I[w]
);
constraint forall(w in Weeks) (
  prod_II[w] <= backlog_II[w-1] + demand_II[w]
);

%%%%%%%%%%%%
% Objective (scaled by PEN_SCALE to keep integer)
%%%%%%%%%%%%
var int: total_cost_scaled =
  sum(w in Weeks)(
      PEN_SCALE * wage_skilled_normal * available_skilled[w]
    + PEN_SCALE * wage_new * available_new[w]
    + PEN_SCALE * (wage_skilled_overtime - wage_skilled_normal) * overtime_workers[w]
    + PEN_SCALE * wage_trainee * in_training[w]
    + pen_I * backlog_I[w]
    + pen_II * backlog_II[w]
  );

solve minimize total_cost_scaled;

%%%%%%%%%%%%
% Output (optional)
%%%%%%%%%%%%
output [
  "Total cost (yuan) = ", show(total_cost_scaled div PEN_SCALE), "\n",
  "Week | trainers_start | trainees_start | avail_skilled | avail_new | overtime | backlog_I | backlog_II\n",
  concat([ show(w) ++ "    | "
           ++ show(trainers_start[w]) ++ "             | "
           ++ show(trainees_start[w]) ++ "            | "
           ++ show(available_skilled[w]) ++ "           | "
           ++ show(available_new[w]) ++ "        | "
           ++ show(overtime_workers[w]) ++ "       | "
           ++ show(backlog_I[w]) ++ "     | "
           ++ show(backlog_II[w]) ++ "\n"
         | w in Weeks ])
];