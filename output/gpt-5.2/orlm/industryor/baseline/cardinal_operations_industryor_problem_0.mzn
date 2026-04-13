% Factory production + training + overtime planning (8 weeks)
% Minimize total wage + delay compensation costs
% All data embedded.

int: W = 8;
set of int: Weeks = 1..W;

% Demand per week (kg)
array[Weeks] of int: demandI  = [10000,10000,12000,12000,16000,16000,20000,20000];
array[Weeks] of int: demandII = [ 6000, 7200, 8400,10800,10800,12000,12000,12000];

% Workforce
int: initial_skilled = 50;
int: target_new_trained_by_end = 50;

% Work hours and productivity (kg/h per worker)
int: h_normal = 40;
int: h_overtime = 60;
int: prodI_per_h = 10;
int: prodII_per_h = 6;

% Training
int: training_len = 2;          % weeks
int: trainees_per_trainer = 3;  % per 2-week training
% During training: trainer + trainees produce 0

% Wages (yuan per worker-week)
int: wage_skilled_normal = 360;  % 40h
int: wage_skilled_ot = 540;      % 60h
int: wage_trainee_in_training = 120;
int: wage_new_after_training = 240; % per week, same efficiency as skilled

% Delay compensation (yuan per kg per week of delay)
float: penI = 0.5;
float: penII = 0.6;

% Decision variables
array[Weeks] of var 0..initial_skilled: skilled_ot;      % skilled working 60h in week t
array[Weeks] of var 0..initial_skilled: trainers_start;  % skilled starting a 2-week training at week t
array[Weeks] of var 0..target_new_trained_by_end: trainees_start; % new workers entering training at week t

% Production split (kg)
array[Weeks] of var 0..1000000: prodI;
array[Weeks] of var 0..1000000: prodII;

% Backlog / delayed deliveries (kg) carried week-to-week
array[0..W] of var 0..1000000: backI;
array[0..W] of var 0..1000000: backII;

% Helpers: number in training / available by week
array[Weeks] of var 0..initial_skilled: trainers_active;
array[Weeks] of var 0..target_new_trained_by_end: trainees_active;
array[Weeks] of var 0..target_new_trained_by_end: new_available;

constraint backI[0] = 0;
constraint backII[0] = 0;

% Training activity windows
constraint
  forall(t in Weeks)(
    trainers_active[t] =
      (if t>=1 then trainers_start[t] else 0 endif) +
      (if t>=2 then trainers_start[t-1] else 0 endif)
  );

constraint
  forall(t in Weeks)(
    trainees_active[t] =
      (if t>=1 then trainees_start[t] else 0 endif) +
      (if t>=2 then trainees_start[t-1] else 0 endif)
  );

% Trainees started must match trainer capacity (3 trainees per trainer start)
constraint forall(t in Weeks)(
  trainees_start[t] = trainees_per_trainer * trainers_start[t]
);

% New workers become available after 2 weeks
constraint forall(t in Weeks)(
  new_available[t] =
    (if t>=3 then sum(k in 1..t-2)(trainees_start[k]) else 0 endif)
);

% By end of week 8, 50 new workers trained
constraint sum(t in Weeks)(trainees_start[t]) = target_new_trained_by_end;

% Cannot start training too late to finish by end of week 8
constraint trainers_start[W] = 0;
constraint trainers_start[W-1] = 0;

% Skilled workforce availability each week (initial skilled only; new workers are separate)
array[Weeks] of var 0..initial_skilled: skilled_available;
constraint forall(t in Weeks)(
  skilled_available[t] = initial_skilled - trainers_active[t]
);

% Overtime skilled must be subset of skilled available (not in training)
constraint forall(t in Weeks)(
  skilled_ot[t] <= skilled_available[t]
);

% Production capacity each week
% - Skilled available work either 40h (normal) or 60h (overtime)
% - New workers available always work 40h at their wage (no overtime option modeled for them)
var int: bigM = 1000000000;

array[Weeks] of var 0..bigM: capI;
array[Weeks] of var 0..bigM: capII;

% Total labor-hours available for production in week t:
% skilled_normal: (skilled_available - skilled_ot) * 40
% skilled_ot: skilled_ot * 60
% new_workers: new_available * 40
array[Weeks] of var 0..bigM: total_hours;
constraint forall(t in Weeks)(
  total_hours[t] =
    (skilled_available[t] - skilled_ot[t]) * h_normal +
    skilled_ot[t] * h_overtime +
    new_available[t] * h_normal
);

% Enforce production hours allocation via capacity constraint:
% Let xI be hours spent on product I; then prodI = 10*xI, prodII = 6*(total_hours-xI)
% Use integer hours to keep integral production; since demands are multiples, this is fine.
array[Weeks] of var 0..bigM: hoursI;
constraint forall(t in Weeks)(
  hoursI[t] <= total_hours[t]
);
constraint forall(t in Weeks)(
  prodI[t] = prodI_per_h * hoursI[t]
);
constraint forall(t in Weeks)(
  prodII[t] = prodII_per_h * (total_hours[t] - hoursI[t])
);

% Demand satisfaction with backlog (delay)
% back[t] = unmet demand carried to next week
constraint forall(t in Weeks)(
  backI[t] = backI[t-1] + demandI[t] - prodI[t]
);
constraint forall(t in Weeks)(
  backII[t] = backII[t-1] + demandII[t] - prodII[t]
);

% Cannot overdeliver (no inventory); equivalently backlog must be nonnegative
constraint forall(t in 0..W)(backI[t] >= 0 /\ backII[t] >= 0);

% Costs
var int: wage_cost =
  sum(t in Weeks)(
      (skilled_available[t] - skilled_ot[t]) * wage_skilled_normal +
      skilled_ot[t] * wage_skilled_ot +
      trainers_active[t] * wage_skilled_normal +   % trainers are skilled but not producing, paid normal
      trainees_active[t] * wage_trainee_in_training +
      new_available[t] * wage_new_after_training
  );

% Delay cost: pay penalty per kg per week of delay, modeled as backlog each week
var float: delay_cost =
  sum(t in Weeks)(
    penI  * int2float(backI[t]) +
    penII * int2float(backII[t])
  );

var float: total_cost = int2float(wage_cost) + delay_cost;

solve minimize total_cost;

output [
  "Total cost = ", show(total_cost), "\n",
  "Wage cost  = ", show(wage_cost), "\n",
  "Delay cost = ", show(delay_cost), "\n\n",
  "Week | trainers_start | trainees_start | skilled_ot | new_available | prodI | prodII | backI | backII\n"
] ++
[
  show(t) ++ "    | " ++
  show(trainers_start[t]) ++ "             | " ++
  show(trainees_start[t]) ++ "            | " ++
  show(skilled_ot[t]) ++ "        | " ++
  show(new_available[t]) ++ "          | " ++
  show(prodI[t]) ++ " | " ++
  show(prodII[t]) ++ "  | " ++
  show(backI[t]) ++ " | " ++
  show(backII[t]) ++ "\n"
  | t in Weeks
];