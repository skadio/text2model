% Parameters (with values embedded)
int: W = 8;
set of int: Weeks = 1..W;

int: init_skilled = 50;          % initial skilled workers available at start of week 1
int: total_new_needed = 50;      % total new workers to be trained by end of week 8

int: hours_normal = 40;
int: hours_overtime = 60;

% Productivity (kg per hour per worker)
int: prodI_per_h = 10;
int: prodII_per_h = 6;

% Weekly demands (kg)
array[Weeks] of int: demandI = [10000, 10000, 12000, 12000, 16000, 16000, 20000, 20000];
array[Weeks] of int: demandII = [ 6000,  7200,  8400, 10800, 10800, 12000, 12000, 12000];

% Wages (yuan per worker-week)
int: wage_skilled_normal = 360;   % 40h
int: wage_skilled_overtime = 540; % 60h
int: wage_trainee = 120;          % during training
int: wage_new = 240;              % after training (same efficiency as skilled)

% Training parameters
int: train_weeks = 2;             % training duration (weeks)
int: trainees_per_trainer = 3;    % a skilled trainer can train up to 3 new workers in 2 weeks

% Delay penalty (yuan per kg per week of delay) -> modeled via backlog carried week to week
float: penI = 0.5;
float: penII = 0.6;

% Big-M style bounds
int: max_workers = init_skilled + total_new_needed; % 100
int: max_train_starts_per_week = total_new_needed;  % 50
int: max_prodI_week = max_workers * hours_overtime * prodI_per_h; % 100*60*10=60000
int: max_prodII_week = max_workers * hours_overtime * prodII_per_h; % 100*60*6=36000

% Variables
% Workforce assignment each week
array[Weeks] of var 0..max_workers: skilled_ot;        % skilled workers working 60h
array[Weeks] of var 0..max_workers: skilled_normal;    % skilled workers working 40h
array[Weeks] of var 0..max_workers: skilled_training;  % skilled workers serving as trainers (inactive in production)

array[Weeks] of var 0..max_workers: new_ot;            % trained new workers working 60h
array[Weeks] of var 0..max_workers: new_normal;        % trained new workers working 40h

% Training pipeline (start counts)
array[Weeks] of var 0..max_train_starts_per_week: start_train;  % trainees entering training at start of week t

% Production split (kg) by product and week
array[Weeks] of var 0..max_prodI_week: prodI;
array[Weeks] of var 0..max_prodII_week: prodII;

% Backlogs (undelivered demand carried forward), kg
array[0..W] of var 0..100000: backlogI;
array[0..W] of var 0..100000: backlogII;

% Helper: number of trainees in training during week t
array[Weeks] of var 0..total_new_needed: trainees_in_training;

% Helper: number of trained new workers available in week t (not in training)
array[Weeks] of var 0..total_new_needed: new_available;

% Constraints
constraint backlogI[0] = 0;
constraint backlogII[0] = 0;

% Training occupancy: trainees who started this week or previous week are in training
constraint forall(t in Weeks) (
  trainees_in_training[t] =
    start_train[t] + (if t >= 2 then start_train[t-1] else 0 endif)
);

% Total trainees trained by end of week 8 must be 50
constraint sum(t in Weeks)(start_train[t]) = total_new_needed;

% New workers become available starting week t if they started training at t-2
constraint forall(t in Weeks) (
  new_available[t] =
    sum(k in 1..t)(
      if k <= t - train_weeks then start_train[k] else 0 endif
    )
);

% Capacity of trainers: each trainer can support up to 3 trainees (over the 2-week period),
% so in any week: trainees_in_training[t] <= 3 * skilled_training[t]
constraint forall(t in Weeks)(
  trainees_in_training[t] <= trainees_per_trainer * skilled_training[t]
);

% Skilled workforce availability: initial skilled must be split among OT/normal/training
constraint forall(t in Weeks)(
  skilled_ot[t] + skilled_normal[t] + skilled_training[t] = init_skilled
);

% New workforce availability: available new workers split into OT/normal; none of these are in training
constraint forall(t in Weeks)(
  new_ot[t] + new_normal[t] = new_available[t]
);

% Production time allocation: choose how many total worker-hours go to I; remaining goes to II.
% Let H_total[t] be total production hours from (skilled OT/normal + new OT/normal)
% prodI[t] = 10 * hours_for_I, prodII[t] = 6 * (H_total - hours_for_I)
array[Weeks] of var 0..(max_workers*hours_overtime): hours_for_I;
array[Weeks] of var 0..(max_workers*hours_overtime): total_prod_hours;

constraint forall(t in Weeks)(
  total_prod_hours[t] =
    hours_overtime * (skilled_ot[t] + new_ot[t]) +
    hours_normal   * (skilled_normal[t] + new_normal[t])
);

constraint forall(t in Weeks)(
  hours_for_I[t] <= total_prod_hours[t]
);

constraint forall(t in Weeks)(
  prodI[t] = prodI_per_h * hours_for_I[t]
);

constraint forall(t in Weeks)(
  prodII[t] = prodII_per_h * (total_prod_hours[t] - hours_for_I[t])
);

% Demand satisfaction with backlogging:
% backlog[t] = backlog[t-1] + demand[t] - production[t], but cannot go below 0
constraint forall(t in Weeks)(
  backlogI[t] >= backlogI[t-1] + demandI[t] - prodI[t]
);
constraint forall(t in Weeks)(
  backlogI[t] >= 0
);
constraint forall(t in Weeks)(
  backlogII[t] >= backlogII[t-1] + demandII[t] - prodII[t]
);
constraint forall(t in Weeks)(
  backlogII[t] >= 0
);

% Also prevent "over-delivery beyond clearing backlog + demand" from creating negative backlog implicitly:
constraint forall(t in Weeks)(
  prodI[t] <= backlogI[t-1] + demandI[t]
);
constraint forall(t in Weeks)(
  prodII[t] <= backlogII[t-1] + demandII[t]
);

% Objective
% Total cost = wages + delay penalties (penalty per kg per week of delay = backlog at end of week)
var float: total_wage =
  sum(t in Weeks)(
    wage_skilled_overtime * skilled_ot[t] +
    wage_skilled_normal   * skilled_normal[t] +
    wage_skilled_normal   * skilled_training[t] +   % trainers are skilled workers (paid skilled wage)
    wage_new              * new_ot[t] +             % new workers paid same regardless of OT? (not specified)
    wage_new              * new_normal[t] +
    wage_trainee          * trainees_in_training[t]
  );

% Note: overtime wage is specified for "some workers"; we apply it to both skilled and new when scheduled OT.
% If overtime is intended only for skilled, set new_ot[t]=0 or pay wage_new instead. Kept consistent with OT assignment.
constraint forall(t in Weeks)(new_ot[t] = 0); % overtime only allowed for (initial) skilled workers per description

constraint total_wage =
  sum(t in Weeks)(
    wage_skilled_overtime * skilled_ot[t] +
    wage_skilled_normal   * skilled_normal[t] +
    wage_skilled_normal   * skilled_training[t] +
    wage_new              * (new_normal[t] + new_ot[t]) +
    wage_trainee          * trainees_in_training[t]
  );

var float: total_penalty =
  sum(t in Weeks)(
    penI * int2float(backlogI[t]) +
    penII * int2float(backlogII[t])
  );

var float: total_cost = total_wage + total_penalty;

solve minimize total_cost;