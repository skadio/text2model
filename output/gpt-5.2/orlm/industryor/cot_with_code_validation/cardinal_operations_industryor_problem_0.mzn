% Parameters
int: W = 8;

set of int: Weeks = 1..W;
set of int: Foods = 1..2; % 1 = I, 2 = II

array[Foods, Weeks] of int: demand = 
  array2d(Foods, Weeks,
  [ 10000, 10000, 12000, 12000, 16000, 16000, 20000, 20000,   % Food I
     6000,  7200,  8400, 10800, 10800, 12000, 12000, 12000 ]);% Food II

int: skilled_initial = 50;

int: hours_normal = 40;
int: hours_overtime = 60;

% production rates (kg per hour per worker)
array[Foods] of int: rate = [10, 6];

% wages (yuan per worker per week)
int: wage_skilled_normal = 360;
int: wage_skilled_overtime = 540;
int: wage_trainee = 120;
int: wage_new_normal = 240;
int: wage_new_overtime = 540; % assume same overtime wage applies to any worker assigned to 60h

% training parameters
int: train_len = 2;        % weeks
int: train_cap = 3;        % one trainer can train up to 3 trainees in 2 weeks
int: new_workers_target = 50;

% delay penalties (yuan per kg per week of delay)
array[Foods] of float: penalty = [0.5, 0.6];

% Big-M style upper bounds for production and backlog
int: max_workers_total = skilled_initial + new_workers_target; % by design
int: max_hours = hours_overtime;
array[Foods] of int: max_prod_week = [max_workers_total*max_hours*rate[1],
                                     max_workers_total*max_hours*rate[2]];
array[Foods] of int: max_total_demand = [sum(w in Weeks)(demand[1,w]),
                                        sum(w in Weeks)(demand[2,w])];

% Variables
% training starts in week w (1..W-1), lasts weeks w and w+1
array[1..W-1] of var 0..new_workers_target: start_trainees;

% number of trainers engaged in training in week w (derived)
array[Weeks] of var 0..skilled_initial: trainers_in_week;

% workforce allocation by week
array[Weeks] of var 0..skilled_initial: skilled_prod;     % initial skilled in production
array[Weeks] of var 0..skilled_initial: skilled_ot;       % initial skilled working overtime (subset of production)
array[Weeks] of var 0..max_workers_total: new_prod;       % trained new workers in production
array[Weeks] of var 0..max_workers_total: new_ot;         % trained new workers working overtime

array[Weeks] of var 0..new_workers_target: trainees_in_week; % trainees (in training, not producing)

% production quantities
array[Foods, Weeks] of var 0..max_prod_week[1]: prod; % bounds adjusted by constraints per food

% backlog (undelivered demand at end of each week)
array[Foods, Weeks] of var 0..max_total_demand[1]: backlog; % bounds adjusted by constraints per food

var float: total_cost;

% Constraints
% Fix per-food bounds that depend on food index
constraint forall(w in Weeks)(
  prod[1,w] <= max_prod_week[1] /\
  prod[2,w] <= max_prod_week[2]
);
constraint forall(w in Weeks)(
  backlog[1,w] <= max_total_demand[1] /\
  backlog[2,w] <= max_total_demand[2]
);

% trainers in each week: trainers engaged are those starting this week or last week
constraint trainers_in_week[1] = start_trainees[1] div train_cap + if start_trainees[1] mod train_cap > 0 then 1 else 0 endif;
constraint forall(w in 2..W-1)(
  trainers_in_week[w] =
    (start_trainees[w] div train_cap + if start_trainees[w] mod train_cap > 0 then 1 else 0 endif) +
    (start_trainees[w-1] div train_cap + if start_trainees[w-1] mod train_cap > 0 then 1 else 0 endif)
);
constraint trainers_in_week[W] =
  (start_trainees[W-1] div train_cap + if start_trainees[W-1] mod train_cap > 0 then 1 else 0 endif);

% training headcount each week
constraint trainees_in_week[1] = start_trainees[1];
constraint forall(w in 2..W-1)(
  trainees_in_week[w] = start_trainees[w] + start_trainees[w-1]
);
constraint trainees_in_week[W] = start_trainees[W-1];

% cannot train more than available initial skilled as trainers
constraint forall(w in Weeks)(
  trainers_in_week[w] <= skilled_initial
);

% total trained new workers by end of week 8 equals target
constraint sum(w in 1..W-1)(start_trainees[w]) = new_workers_target;

% skilled workforce balance per week: either producing or training
constraint forall(w in Weeks)(
  skilled_prod[w] + trainers_in_week[w] = skilled_initial
);

% overtime subsets
constraint forall(w in Weeks)(
  skilled_ot[w] <= skilled_prod[w] /\
  new_ot[w] <= new_prod[w]
);

% number of trained new workers available for production each week
% those who started training in weeks <= w-2 have completed by week w
constraint new_prod[1] = 0;
constraint new_prod[2] = 0;
constraint forall(w in 3..W)(
  new_prod[w] <= sum(k in 1..w-2)(start_trainees[k])
);

% non-overtime workers in production are those in production but not overtime
array[Weeks] of var 0..max_workers_total: skilled_norm;
array[Weeks] of var 0..max_workers_total: new_norm;

constraint forall(w in Weeks)(
  skilled_norm[w] = skilled_prod[w] - skilled_ot[w] /\
  new_norm[w] = new_prod[w] - new_ot[w]
);

% production capacity in kg each week per food
% total kg = rate * (40h*normal_workers + 60h*overtime_workers)
constraint forall(f in Foods, w in Weeks)(
  prod[f,w] =
    rate[f] * (
      hours_normal * (skilled_norm[w] + new_norm[w]) +
      hours_overtime * (skilled_ot[w] + new_ot[w])
    )
);

% backlog dynamics: backlog[w] = backlog[w-1] + demand[w] - prod[w], with nonnegativity
constraint forall(f in Foods)(
  backlog[f,1] >= demand[f,1] - prod[f,1] /\
  backlog[f,1] >= 0
);
constraint forall(f in Foods, w in 2..W)(
  backlog[f,w] >= backlog[f,w-1] + demand[f,w] - prod[f,w] /\
  backlog[f,w] >= 0
);

% Also ensure we don't "over-ship" beyond clearing backlog (optional but tightens)
constraint forall(f in Foods, w in Weeks)(
  prod[f,w] <= (if w=1 then demand[f,1] else backlog[f,w-1] + demand[f,w] endif)
);

% Objective
% total wages + delay penalties (penalty * backlog at end of each week)
constraint
  total_cost =
    % wages for initial skilled
    sum(w in Weeks)(
      wage_skilled_normal * skilled_norm[w] +
      wage_skilled_overtime * skilled_ot[w] +
      wage_trainee * trainees_in_week[w] +
      wage_new_normal * new_norm[w] +
      wage_new_overtime * new_ot[w]
    )
    +
    % backlog penalties
    sum(f in Foods, w in Weeks)(
      penalty[f] * int2float(backlog[f,w])
    );

solve minimize total_cost;